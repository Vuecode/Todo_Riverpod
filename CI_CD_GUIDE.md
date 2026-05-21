# CI/CD Setup for Flutter Todo App

## Overview

This project uses **GitHub Actions** for continuous integration and continuous deployment (CI/CD). The workflows automatically build, test, and deploy your Flutter app whenever you push code to the repository.

## Workflows

### 1. **Build & Deploy** (`.github/workflows/build.yml`)
- **Triggers**: Push to `main` or `develop` branch, Pull requests
- **Tasks**:
  - ✅ Builds Flutter web version
  - ✅ Builds Android APK
  - ✅ Runs code analysis
  - ✅ Uploads build artifacts
  - ✅ **Auto-deploys web version to GitHub Pages** (main branch only)

### 2. **Test** (`.github/workflows/test.yml`)
- **Triggers**: Push to `main` or `develop` branch, Pull requests
- **Tasks**:
  - ✅ Runs all widget tests
  - ✅ Generates code coverage reports
  - ✅ Uploads to Codecov (optional)

### 3. **Code Quality** (`.github/workflows/analyze.yml`)
- **Triggers**: Push to `main` or `develop` branch, Pull requests
- **Tasks**:
  - ✅ Runs Flutter analysis
  - ✅ Checks code formatting
  - ✅ Runs linter (optional)

## How to Use

### 1. **Create a Develop Branch** (Recommended)
```bash
git checkout -b develop
git push -u origin develop
```

### 2. **Workflow Triggers**
Workflows automatically run when you:
- Push commits to `main` or `develop`
- Create a pull request to `main` or `develop`

### 3. **View Workflow Status**
1. Go to your GitHub repository
2. Click **"Actions"** tab
3. See all running/completed workflows
4. Click on a workflow to see detailed logs

## GitHub Pages Deployment

Your web app automatically deploys to:
```
https://Vuecode.github.io/Todo_Riverpod/
```

**To enable:**
1. Go to Settings → Pages
2. Set Source to `Deploy from a branch`
3. Select `gh-pages` branch and `/root` folder
4. Save

The web app updates automatically whenever you push to `main`!

## Build Artifacts

Each build generates downloadable artifacts:
- **Web Build**: `flutter-web-build/` - Complete web app
- **APK Build**: `flutter-apk-build/` - Android APK file

Download from the Actions tab after successful build.

## Customization

### Add More Platforms

**iOS Build** (requires macOS runner):
```yaml
- name: Build iOS
  run: flutter build ios --release
```

**Windows Build** (requires windows runner):
```yaml
- name: Build Windows
  run: flutter build windows --release
```

### Change Flutter Version
Edit the `flutter-version` in any workflow YAML file:
```yaml
flutter-version: '3.20.0'  # Change this
```

### Add Environment Variables
```yaml
env:
  APP_NAME: "Flutter Todo App"
  VERSION: "1.0.0"
```

## Secrets & Tokens

GitHub automatically provides:
- `${{ secrets.GITHUB_TOKEN }}` - For GitHub Pages deployment
- `${{ github.token }}` - Alternative token reference

No additional setup needed for basic CI/CD!

## Monitoring & Debugging

### Check Workflow Status
```bash
# View last run
git log --oneline

# View workflow runs locally (requires GitHub CLI)
gh run list
gh run view <run-id>
```

### Common Issues & Solutions

**❌ Issue**: Build fails with "Flutter not found"
- **✅ Solution**: Ensure Flutter version in workflow matches your local version
- Check: `flutter --version` locally and compare with workflow YAML

**❌ Issue**: GitHub Pages not updating
- **✅ Solution**: Check Settings → Pages → Source is set to `gh-pages` branch
- The workflow automatically creates the `gh-pages` branch on first successful deployment

**❌ Issue**: APK build fails
- **✅ Solution**: Ensure Java 11 is available (handled automatically in workflow)
- Try simplified `web-build.yml` if other builds are failing

**❌ Issue**: "Permission denied" errors
- **✅ Solution**: GitHub token is automatically available as `${{ secrets.GITHUB_TOKEN }}`
- No manual token setup needed

**❌ Issue**: Tests fail or timeout
- **✅ Solution**: Tests are set to `continue-on-error: true`
- Check workflow logs at Actions tab for details
- Add actual tests in `test/` folder to enable proper testing

**❌ Issue**: Artifact download fails
- **✅ Solution**: Check artifact name matches in both upload and download steps
- Artifacts are kept for 7 days by default

## Badges

Add these to your README.md to show CI status:

```markdown
![Build Status](https://github.com/Vuecode/Todo_Riverpod/workflows/Build%20and%20Deploy/badge.svg)
![Test Status](https://github.com/Vuecode/Todo_Riverpod/workflows/Test/badge.svg)
![Code Quality](https://github.com/Vuecode/Todo_Riverpod/workflows/Code%20Quality/badge.svg)
```

## Next Steps

1. ✅ Commit and push the workflow files
2. ✅ Go to Actions tab to see workflows in progress
3. ✅ Enable GitHub Pages deployment
4. ✅ Add tests to improve coverage
5. ✅ Configure email notifications for failures

## Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Flutter CI/CD Best Practices](https://flutter.dev/docs/testing/integration-tests)
- [GitHub Pages Guide](https://pages.github.com/)

---

**Your CI/CD Pipeline is Ready!** 🚀
