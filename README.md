# HTML Reader – Android browser-style app

A simple **Android app** that works like a browser (HTML reader) with a **native Android UI**: toolbar, URL bar, back/forward/refresh, and a WebView for web content.

## Features

- **URL bar** – Enter any web address or search (opens Google by default).
- **Back / Forward** – Navigate history.
- **Refresh** – Reload the current page.
- **Progress bar** – Shows load progress under the toolbar.
- **Hardware back** – Goes back in WebView history, or exits the app when there’s no history.

## How to build the APK

### Option 1: Build without Android Studio (script)

1. Install **Java 17+** and the **Android SDK** (command-line tools). Full steps: see **[SETUP-NO-STUDIO.md](SETUP-NO-STUDIO.md)**.
2. Set **ANDROID_HOME** to your SDK folder (e.g. `D:\android-sdk`).
3. In PowerShell, from the project folder, run:
   ```powershell
   .\build-apk.ps1
   ```
4. The APK will be at: `app\build\outputs\apk\debug\app-debug.apk`

### Option 2: Android Studio

1. Install [Android Studio](https://developer.android.com/studio).
2. **File → Open** and select the project folder (`d:\New folder`).
3. Wait for Gradle sync to finish.
4. **Build → Build Bundle(s) / APK(s) → Build APK(s)**.
5. The APK will be at: `app/build/outputs/apk/debug/app-debug.apk`

## Requirements

- **minSdk 24** (Android 7.0)
- **targetSdk 34** (Android 14)
- **Internet** permission (for loading web pages)

## Project structure

- `app/src/main/java/com/htmlreader/app/MainActivity.kt` – WebView + URL bar and buttons.
- `app/src/main/res/layout/activity_main.xml` – Toolbar, URL bar, WebView layout.
- `app/src/main/AndroidManifest.xml` – Launcher activity and `INTERNET` permission.

The app uses a single full-screen activity with a Material-style toolbar and a WebView, so it looks and feels like a normal Android app while acting like a simple browser/HTML reader.
