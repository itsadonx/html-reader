package com.htmlreader.app

import android.annotation.SuppressLint
import android.content.Intent
import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.print.PrintAttributes
import android.print.PrintManager
import android.view.View
import android.webkit.JavascriptInterface
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.ProgressBar
import android.widget.Toast
import androidx.activity.OnBackPressedCallback
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.content.edit

class MainActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private lateinit var progressBar: ProgressBar
    private lateinit var toolbar: Toolbar

    private val prefs by lazy { getSharedPreferences("html_reader", MODE_PRIVATE) }
    private val lastUriKey = "last_html_uri"

    private val openFileLauncher = registerForActivityResult(
        ActivityResultContracts.OpenDocument()
    ) { uri: Uri? ->
        if (uri != null) {
            saveAndLoadUri(uri)
        } else {
            Toast.makeText(this, "No file selected", Toast.LENGTH_SHORT).show()
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        toolbar = findViewById(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayShowTitleEnabled(false)

        webView = findViewById(R.id.webView)
        progressBar = findViewById(R.id.progressBar)

        webView.settings.apply {
            javaScriptEnabled = true
            domStorageEnabled = true
            loadWithOverviewMode = true
            useWideViewPort = true
            allowFileAccess = true
            allowContentAccess = true
        }

        webView.addJavascriptInterface(PrintBridge(this), "HtmlReaderPrint")

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(
                view: WebView?,
                request: WebResourceRequest?
            ): Boolean {
                request?.url?.toString()?.let { url ->
                    if (!url.startsWith("file://") && !url.startsWith("content://")) {
                        view?.loadUrl(url)
                    }
                }
                return false
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                progressBar.visibility = View.VISIBLE
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                progressBar.visibility = View.GONE
                injectPrintOverride(view)
            }
        }

        webView.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView?, newProgress: Int) {
                progressBar.progress = newProgress
            }
        }

        toolbar.setOnMenuItemClickListener { item ->
            when (item.itemId) {
                R.id.action_open_file -> {
                    openHtmlFilePicker()
                    true
                }
                R.id.action_print -> {
                    printCurrentPage()
                    true
                }
                else -> false
            }
        }

        if (savedInstanceState != null) {
            webView.restoreState(savedInstanceState)
        } else {
            val savedUri = prefs.getString(lastUriKey, null)
            if (savedUri != null) {
                try {
                    loadUri(Uri.parse(savedUri))
                } catch (_: Exception) {
                    loadBundledHtml()
                }
            } else {
                loadBundledHtml()
            }
        }

        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                if (webView.canGoBack()) webView.goBack()
                else {
                    isEnabled = false
                    onBackPressedDispatcher.onBackPressed()
                }
            }
        })
    }

    private fun openHtmlFilePicker() {
        openFileLauncher.launch(arrayOf("text/html", "text/*", "*/*"))
    }

    private fun saveAndLoadUri(uri: Uri) {
        try {
            contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
        } catch (_: SecurityException) { }
        prefs.edit { putString(lastUriKey, uri.toString()) }
        loadUri(uri)
    }

    private fun loadUri(uri: Uri) {
        webView.loadUrl(uri.toString())
    }

    private fun loadBundledHtml() {
        webView.loadUrl("file:///android_asset/index.html")
    }

    private fun injectPrintOverride(webView: WebView?) {
        if (webView == null) return
        val script = """
            (function() {
                var doPrint = function() {
                    var w = window.top || window;
                    if (w.HtmlReaderPrint && typeof w.HtmlReaderPrint.print === 'function') {
                        w.HtmlReaderPrint.print();
                    }
                };
                try {
                    window.print = doPrint;
                    if (typeof Object.defineProperty === 'function') {
                        try {
                            Object.defineProperty(window, 'print', { value: doPrint, writable: true, configurable: true });
                        } catch (e) {}
                    }
                } catch (e) {}
                try {
                    var frames = document.getElementsByTagName('iframe');
                    for (var i = 0; i < frames.length; i++) {
                        try {
                            if (frames[i].contentWindow) frames[i].contentWindow.print = doPrint;
                        } catch (e) {}
                    }
                } catch (e) {}
            })();
        """.trimIndent()
        fun runInject() {
            webView.evaluateJavascript(script, null)
        }
        webView.postDelayed({ runInject() }, 200)
        webView.postDelayed({ runInject() }, 800)
        webView.postDelayed({ runInject() }, 2000)
    }

    private fun printCurrentPage() {
        val printManager = getSystemService(Context.PRINT_SERVICE) as? PrintManager
        if (printManager == null) {
            Toast.makeText(this, "Print not available", Toast.LENGTH_SHORT).show()
            return
        }
        val jobName = "HTML Reader Document"
        val adapter = webView.createPrintDocumentAdapter(jobName)
        try {
            printManager.print(jobName, adapter, PrintAttributes.Builder().build())
        } catch (e: Exception) {
            Toast.makeText(this, "Print failed: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    class PrintBridge(private val activity: MainActivity) {
        @JavascriptInterface
        fun print() {
            activity.runOnUiThread {
                activity.webView.post {
                    activity.printCurrentPage()
                }
            }
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        webView.saveState(outState)
    }
}
