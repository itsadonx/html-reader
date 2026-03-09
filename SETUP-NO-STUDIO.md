# Build the APK Without Android Studio

You need two things installed: **Java** and the **Android SDK**. Then run the build script.

---

## Step 1: Install Java (JDK 17 or later)

1. Go to **https://adoptium.net/temurin/releases/**
2. Choose **Windows**, **x64**, **JDK 17** (or 21), and download the **.msi** installer.
3. Run the installer. Make sure the option to **add to PATH** is checked.
4. Open a **new** PowerShell window and run:
   ```powershell
   java -version
   ```
   You should see a version like `openjdk version "17.x.x"`.

---

## Step 2: Install Android SDK (command-line tools only)

1. **Download** the Windows command-line tools:
   - Go to **https://developer.android.com/studio#command-line-tools-only**
   - Under "Command line tools only", download **Windows** (e.g. `commandlinetools-win-11076708_latest.zip`).

2. **Extract** the zip to a folder, e.g.:
   ```
   D:\android-sdk
   ```
   After extracting, you should have:
   ```
   D:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat
   ```

3. **Install required packages** (run in PowerShell):
   ```powershell
   D:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat --sdk_root=D:\android-sdk "platforms;android-34" "build-tools;34.0.0"
   ```
   Accept licenses when asked (`y` + Enter).

4. **Set ANDROID_HOME** (so the build script finds the SDK):
   - Press **Win + R**, type `sysdm.cpl`, Enter.
   - **Advanced** tab → **Environment Variables**.
   - Under "User variables" (or "System variables"), click **New**:
     - Variable name: `ANDROID_HOME`
     - Variable value: `D:\android-sdk` (or the path you used).
   - Click OK, then **open a new PowerShell window** so the variable is loaded.

---

## Step 3: Run the build script

1. Open PowerShell.
2. Go to the project folder:
   ```powershell
   cd "D:\New folder"
   ```
3. Run:
   ```powershell
   .\build-apk.ps1
   ```
   The first run may download Gradle and take a few minutes. When it finishes successfully, the APK path will be shown and Explorer may open to it.

**APK location:** `D:\New folder\app\build\outputs\apk\debug\app-debug.apk`

---

## If you prefer to install Android Studio instead

- Download: **https://developer.android.com/studio**
- Install it, open this project (**File → Open** → `D:\New folder`), then use **Build → Build Bundle(s) / APK(s) → Build APK(s)**.
- No need to run `build-apk.ps1` if you use Android Studio.
