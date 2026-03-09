# Build the APK Online (No Android Studio, No Local SDK)

Use **GitHub’s free cloud build** to generate the APK. You only need a GitHub account and a few clicks.

---

## Step 1: Put the project on GitHub

1. **Create a GitHub account** (if you don’t have one): https://github.com/join  

2. **Create a new repository**  
   - Go to https://github.com/new  
   - Repository name: e.g. `html-reader`  
   - Choose **Public**  
   - Do **not** add a README or .gitignore (your folder already has files)  
   - Click **Create repository**  

3. **Push this project to the new repo**  
   - Install **Git**: https://git-scm.com/download/win  
   - Open **PowerShell** or **Command Prompt** and run:

   ```powershell
   cd "D:\New folder"
   git init
   git add .
   git commit -m "Initial commit - HTML Reader app"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/html-reader.git
   git push -u origin main
   ```
   Replace `YOUR_USERNAME` and `html-reader` with your GitHub username and repo name.

---

## Step 2: Run the build

1. After you push, go to your repo on GitHub: `https://github.com/YOUR_USERNAME/html-reader`  
2. Open the **Actions** tab.  
3. You should see a workflow run for “Build APK” (triggered by the push).  
   - If not, click **Build APK** in the left sidebar, then **Run workflow** → **Run workflow**.  
4. Wait for the run to finish (about 5–10 minutes). The status will turn green when it succeeds.

---

## Step 3: Download the APK

1. Open the **completed** workflow run (click it).  
2. Scroll to **Artifacts**.  
3. Click **app-debug** to download a zip that contains `app-debug.apk`.  
4. Unzip it and copy `app-debug.apk` to your Android device to install.

---

## Summary

| Step | What to do |
|------|------------|
| 1 | Create a GitHub repo and push this project with Git |
| 2 | In the repo, go to **Actions** and run / wait for **Build APK** |
| 3 | Download the **app-debug** artifact and use the APK inside |

You can run the build again anytime by pushing new changes or by going to **Actions → Build APK → Run workflow**.
