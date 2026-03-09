# Step-by-step: Get your APK (no Android Studio)

Follow these steps in order. You’ll end up with an **app-debug.apk** file you can install on your phone.

---

## Part A: Get a GitHub account and Git

### Step A1: Create a GitHub account (if you don’t have one)

1. Open your browser and go to: **https://github.com/join**
2. Enter:
   - **Email** (a real email you use)
   - **Password** (make it strong)
   - **Username** (e.g. `johndoe` — this will be in the URL of your repos)
3. Click **Create account**.
4. Confirm your email if GitHub asks you to.
5. You’re in when you see your GitHub home page.

---

### Step A2: Install Git on your computer

1. Go to: **https://git-scm.com/download/win**
2. Click **Click here to download** (64-bit is fine for most PCs).
3. Run the downloaded file (e.g. `Git-2.43.0-64-bit.exe`).
4. In the installer, keep the default options and click **Next** until **Install**, then **Finish**.
5. **Close and reopen** PowerShell or Command Prompt so it finds `git`.

**Check it worked:** Open **PowerShell** and type:
```powershell
git --version
```
You should see something like `git version 2.43.0`. If you see “not recognized”, close all terminals and try again, or run the Git installer again.

---

## Part B: Put your project on GitHub

### Step B1: Create a new empty repository on GitHub

1. Log in to **https://github.com**
2. Click the **+** (plus) at the top right → **New repository**.
3. Fill in:
   - **Repository name:** `html-reader` (or any name you like, e.g. `my-browser-app`)
   - **Public**
   - Leave **README**, **.gitignore**, and **license** **unchecked** (empty repo).
4. Click **Create repository**.
5. You’ll see a page titled “Quick setup” with a URL like `https://github.com/YOUR_USERNAME/html-reader.git`.  
   **Keep this page open** or copy that URL — you’ll use it in Step B3.

---

### Step B2: Turn your project folder into a Git repo and push it

Do this in **PowerShell** (Windows key, type `PowerShell`, press Enter).

**B2.1 – Go to your project folder**
```powershell
cd "D:\New folder"
```
Press Enter.  
*(If your project is somewhere else, use that path instead.)*

**B2.2 – Set your Git identity (do this once per computer)**

Git needs your name and email for the commit. Use the **same email** as your GitHub account, and any name you like:
```powershell
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```
Replace `your-email@example.com` and `Your Name` with your real email and name. Then continue below.

**B2.3 – Initialize Git**
```powershell
git init
```
Press Enter. You should see: `Initialized empty Git repository in D:\New folder\.git\`

**B2.4 – Add all files**
```powershell
git add .
```
Press Enter. (No message is normal.)

**B2.5 – Create the first commit**
```powershell
git commit -m "Initial commit - HTML Reader app"
```
Press Enter. You should see a list of files and “X files changed”.

**B2.6 – Name the main branch**
```powershell
git branch -M main
```
Press Enter.

**B2.7 – Connect to your GitHub repo**

Use the URL from Step B1. Replace `YOUR_USERNAME` with your GitHub username and `html-reader` with your repo name if you chose a different one:
```powershell
git remote add origin https://github.com/YOUR_USERNAME/html-reader.git
```
Example: if your username is `johndoe`, the line is:
```powershell
git remote add origin https://github.com/johndoe/html-reader.git
```
Press Enter.

**B2.8 – Push the code to GitHub**
```powershell
git push -u origin main
```
Press Enter.  
- If GitHub asks you to **log in**, use your GitHub username and a **Personal Access Token** (not your normal password). To create one: GitHub → Settings → Developer settings → Personal access tokens → Generate new token. Give it a name, check “repo”, generate, then paste the token when Git asks for a password.  
- When it finishes you should see something like “Branch 'main' set up to track remote branch 'main' from 'origin'.”

---

## Part C: Build the APK in the cloud

### Step C1: Open the Actions tab

1. In your browser, go to your repo: **https://github.com/YOUR_USERNAME/html-reader** (use your username and repo name).
2. Click the **Actions** tab at the top (between “Pull requests” and “Projects”).

---

### Step C2: Start or find the build

**If you see a run already (e.g. “Build APK” with a yellow dot or “Running”):**  
That’s the build that started when you pushed. Skip to Step C3.

**If you don’t see a run, or you want to run it again:**

1. On the left, click **Build APK**.
2. On the right, click **Run workflow** (dropdown) → **Run workflow** (green button).
3. A new run will appear at the top of the list. Click it.

---

### Step C3: Wait until the build is done

1. You’ll see a list of steps (e.g. “Checkout”, “Set up JDK 17”, “Build debug APK”, “Upload APK”).
2. Wait until all steps have a green tick (about **5–10 minutes**).  
   - **Yellow circle** = still running.  
   - **Green tick** = that step finished successfully.  
   - **Red cross** = that step failed; click it to see the error.

When the whole run shows a **green tick**, the APK was built successfully.

---

## Part D: Download and install the APK

### Step D1: Download the APK from GitHub

1. On the same **Actions** run (the one with the green tick), scroll down to the **Artifacts** section.
2. You’ll see **app-debug** (or similar). Click it.  
   Your browser will download a zip file (e.g. `app-debug.zip`).

---

### Step D2: Get the APK out of the zip

1. Open **File Explorer** and go to your **Downloads** folder.
2. Find the downloaded zip (e.g. `app-debug.zip`).
3. **Right‑click** the zip → **Extract All** → choose a folder (e.g. “Downloads”) → **Extract**.
4. Open the extracted folder. Inside you’ll see **app-debug.apk**. That’s your app.

---

### Step D3: Install the APK on your Android phone

**Option 1 – Copy to phone and open**

1. Connect your phone to the PC with a USB cable (or use cloud storage / email).
2. Copy **app-debug.apk** to your phone (e.g. Downloads folder).
3. On the phone, open **Files** (or “Downloads”) and tap **app-debug.apk**.
4. If Android says “Install blocked”, go to **Settings → Security** and allow installs from that source (e.g. “Files” or “Chrome”), then tap the APK again.
5. Tap **Install**. When it’s done, tap **Open** or find “HTML Reader” in your app list.

**Option 2 – Send to yourself**

1. Email the **app-debug.apk** file to yourself or upload it to Google Drive / OneDrive.
2. On your phone, open the email or Drive, download the file, then tap it and install as above.

---

## Quick checklist

| Part | What you did |
|------|------------------|
| A    | GitHub account + Git installed |
| B    | New repo created + project pushed with `git init`, `git add .`, `git commit`, `git remote add origin`, `git push` |
| C    | Opened **Actions** → **Build APK** run → waited until green |
| D    | Downloaded **app-debug** artifact → unzipped → **app-debug.apk** → copied to phone → installed |

---

## If something goes wrong

- **“git is not recognized”**  
  Install Git (Part A2) and close and reopen PowerShell.

- **“Permission denied” or “Authentication failed” on push**  
  Use a **Personal Access Token** as the password when Git asks (see Step B2.7).

- **Build fails (red cross) on Actions**  
  Click the failed step and read the red error. Often it’s a typo in the repo URL or a missing file. You can fix the project and run `git add .`, `git commit -m "Fix"`, `git push`, then run the workflow again.

- **Phone says “App not installed”**  
  Uninstall any old version of “HTML Reader” first, then install the new APK again.

If you tell me the exact message or step where you’re stuck, I can give you the next step for that part.
