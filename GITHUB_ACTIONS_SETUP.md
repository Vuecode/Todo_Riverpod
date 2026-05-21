# GitHub Actions CI/CD - Complete Setup & Troubleshooting Guide

## 🎯 Quick Start

Your CI/CD pipeline is now live! Here's what happens automatically:

### **Workflow Files**
| File | Purpose | Status |
|------|---------|--------|
| `web-build.yml` | ✅ **USE THIS** - Builds & deploys web app | **RECOMMENDED** |
| `build.yml` | Builds web + APK | May fail on APK |
| `analyze.yml` | Code quality checks | Safe to use |
| `test.yml` | Runs tests | Safe to use |

---

## 📋 Setup Steps

### **Step 1: Enable GitHub Pages**
Your web app needs GitHub Pages to be enabled:

1. Go to: **Settings → Pages**
2. Select **Deploy from a branch**
3. Choose: **Branch: `gh-pages`** and **Folder: `/ (root)`**
4. Click **Save**
5. Wait 1-2 minutes

✅ Your app will be at: `https://Vuecode.github.io/Todo_Riverpod/`

### **Step 2: View Your Workflows**
1. Go to: **Actions** tab in your GitHub repo
2. You'll see workflow runs appear
3. Click on any workflow to see detailed logs

### **Step 3: Trigger a Build**
Make a small code change and push:
```bash
cd "c:\Users\Nitin Katiyar\Downloads\riverpod\todo_app"
git commit -am "Update: Minor improvement"
git push origin main
```

Watch the workflow run automatically! 🚀

---

## 🔧 Recommended Configuration

### **Option A: Web Only (Simplest, Recommended)**

The `web-build.yml` workflow is the most reliable:
- ✅ Builds Flutter web app
- ✅ Deploys to GitHub Pages
- ✅ No Android/APK complications

**Status**: This should work immediately ✅

### **Option B: Full CI/CD (More Advanced)**

If you want all workflows:
1. Use the main `build.yml` for web+APK (may need Android signing)
2. Use `analyze.yml` for code quality
3. Use `test.yml` for unit tests

---

## 📊 Workflow Status Badges

Add these to your README to show build status:

```markdown
![Build Status](https://github.com/Vuecode/Todo_Riverpod/actions/workflows/web-build.yml/badge.svg)
![Code Quality](https://github.com/Vuecode/Todo_Riverpod/actions/workflows/analyze.yml/badge.svg)
![Tests](https://github.com/Vuecode/Todo_Riverpod/actions/workflows/test.yml/badge.svg)
```

---

## 🐛 Troubleshooting Issues

### **Issue 1: Workflow Shows Red X (Failed)**

**Check the logs:**
1. Go to **Actions** tab
2. Click the failed workflow
3. Click the job (e.g., "Build Web Application")
4. Scroll down to see error messages

**Common errors & fixes:**

#### Error: `flutter: Command not found`
- **Cause**: Flutter action didn't download correctly
- **Fix**: 
  ```yaml
  - uses: subosito/flutter-action@v2
    with:
      flutter-version: '3.19.2'
      channel: 'stable'
      cache: true  # Enable caching
  ```

#### Error: `Gradle build failed`
- **Cause**: Java/Gradle issue with APK build
- **Fix**: Use `web-build.yml` instead (no APK = no Gradle issues)

#### Error: `No such file: build/web`
- **Cause**: Web build didn't complete
- **Fix**: Check earlier steps in logs for actual error

---

### **Issue 2: GitHub Pages Not Updating**

**Checklist:**
- [ ] Check Settings → Pages → Source is `gh-pages` branch
- [ ] Check that `gh-pages` branch exists (created after first successful deploy)
- [ ] Wait 5-10 minutes for GitHub to update
- [ ] Hard refresh your browser: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)

**Debug:**
1. Go to Settings → Pages
2. If "gh-pages" branch missing, run workflow manually:
   - Click **Actions** → **Build Web Only** → **Run workflow**

---

### **Issue 3: Artifact Not Found**

**Check:**
1. Did the workflow complete successfully? (Green checkmark)
2. Look for "Artifacts" section in workflow run
3. Artifact names must match exactly:
   - Upload: `name: web-build`
   - Download: `name: web-build` ✅ (must match)

---

### **Issue 4: Permission Errors**

**Error**: "Permission denied" or "Access denied"

**Solution**: GitHub automatically provides `GITHUB_TOKEN`:
```yaml
github_token: ${{ secrets.GITHUB_TOKEN }}  # No setup needed!
```

---

## 🚀 Deployment Details

### **What Gets Built**
1. **Web App**: Flutter web version (runs in browser)
   - Location: `build/web/`
   - Deployed to GitHub Pages automatically
   - URL: `https://Vuecode.github.io/Todo_Riverpod/`

2. **APK** (optional): Android app package
   - Location: `build/app/outputs/flutter-apk/`
   - Downloaded as artifact from Actions tab

### **Deployment Process**
```
Your Code Push
     ↓
GitHub Actions Triggered
     ↓
Build Web App (flutter build web)
     ↓
Create Artifact (upload-artifact)
     ↓
Deploy to GitHub Pages (gh-pages branch)
     ↓
Your App Live! 🎉
```

---

## 📈 Monitoring Your Builds

### **View Build History**
```bash
# See recent commits and their build status
cd "c:\Users\Nitin Katiyar\Downloads\riverpod\todo_app"
git log --oneline --graph

# Or visit: https://github.com/Vuecode/Todo_Riverpod/actions
```

### **Download Build Artifacts**
1. Go to **Actions**
2. Click the workflow run (green checkmark)
3. Scroll to bottom: **Artifacts** section
4. Click to download (valid for 7 days)

### **Build Duration**
- **Web build**: ~2-3 minutes
- **With APK**: ~5-8 minutes
- **With tests**: ~3-4 minutes

---

## ✅ Verification Checklist

- [ ] Workflows are in `.github/workflows/` folder
- [ ] GitHub Pages enabled (Settings → Pages)
- [ ] First workflow has completed (green ✅)
- [ ] Web app accessible at GitHub Pages URL
- [ ] Can see artifacts in Actions tab
- [ ] Status badges showing in README

---

## 🎯 Next Steps

### **Immediate (Do Now)**
1. ✅ Go to **Settings → Pages** and enable it
2. ✅ Check **Actions** tab to see workflow progress
3. ✅ Wait for first deployment to complete

### **Short Term (Do Today)**
1. Make a small code change and push
2. Watch workflow run automatically
3. Visit your GitHub Pages URL
4. Download and test artifacts

### **Long Term (Optional)**
1. Add actual unit tests to `test/` folder
2. Configure APK signing (if needed)
3. Set up email notifications for failures
4. Add more workflows for iOS, Windows, etc.

---

## 📞 Need Help?

**Check GitHub Actions Documentation:**
- https://docs.github.com/actions

**Check Flutter CI/CD Guide:**
- https://flutter.dev/docs/testing/integration-tests

**Common Questions:**

**Q: How often do workflows run?**
A: Every time you push to main/develop branch

**Q: Can I run workflow manually?**
A: Yes! Go to Actions → Select workflow → Click "Run workflow"

**Q: How do I disable a workflow?**
A: Delete the YAML file from `.github/workflows/` folder

**Q: Can I see detailed logs?**
A: Yes! Click workflow run → Click job → See detailed logs

---

## 🎊 You're All Set!

Your Flutter Todo App now has:
- ✅ Automatic builds on every push
- ✅ Automatic deployment to GitHub Pages
- ✅ Code quality checks
- ✅ Test automation
- ✅ Artifact management

**Happy coding!** 🚀
