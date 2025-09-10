# 🚀 Automated Publishing Setup Guide

This guide will help you set up automated publishing for `cache_manager_lite` using GitHub Actions and Git tags.

## 📋 Prerequisites

1. ✅ Package is ready for publishing (0 warnings from `dart pub publish --dry-run`)
2. ✅ GitHub repository is set up
3. ✅ You have publishing rights to pub.dev

## 🔑 Step 1: Set up pub.dev API Token

### 1.1 Generate pub.dev API Token

1. Go to [pub.dev](https://pub.dev/)
2. Sign in with your Google account
3. Go to your account settings: https://pub.dev/my-publishers
4. Click on "Create API Token"
5. Copy the generated token

### 1.2 Run pub.dev Authentication (One-time setup)

Run this command locally to generate credentials:

```bash
dart pub token add https://pub.dev
```

This will open a browser and ask you to authenticate. After authentication, check your credentials file:

**macOS/Linux:**

```bash
cat ~/.pub-cache/credentials.json
```

**Windows:**

```cmd
type %APPDATA%\Pub\Cache\credentials.json
```

The file should look like this:

```json
{
  "accessToken": "ya29.xxx...",
  "refreshToken": "1//xxx...",
  "tokenEndpoint": "https://oauth2.googleapis.com/token",
  "scopes": ["https://www.googleapis.com/auth/userinfo.email", "openid"],
  "expiration": 1234567890123
}
```

## 🔒 Step 2: Configure GitHub Secrets

Go to your GitHub repository settings and add these secrets:

1. **Repository Settings** → **Secrets and variables** → **Actions**
2. Click **"New repository secret"** for each of the following:

### Required Secrets:

| Secret Name                      | Value                                 | Description           |
| -------------------------------- | ------------------------------------- | --------------------- |
| `PUB_DEV_PUBLISH_ACCESS_TOKEN`   | `ya29.xxx...`                         | From credentials.json |
| `PUB_DEV_PUBLISH_REFRESH_TOKEN`  | `1//xxx...`                           | From credentials.json |
| `PUB_DEV_PUBLISH_TOKEN_ENDPOINT` | `https://oauth2.googleapis.com/token` | From credentials.json |
| `PUB_DEV_PUBLISH_EXPIRATION`     | `1234567890123`                       | From credentials.json |

### Note:

- `GITHUB_TOKEN` is automatically provided by GitHub Actions (no setup needed)

## 🏷️ Step 3: Create Your First Release

### Option A: Using the Release Script (Recommended)

```bash
# Run the automated release script
./scripts/release.sh
```

The script will:

- ✅ Check current version in `pubspec.yaml`
- ✅ Allow you to update version if needed
- ✅ Run pre-flight checks (tests, formatting, analysis)
- ✅ Create and push Git tag
- ✅ Trigger automated publishing

### Option B: Manual Git Tag Creation

```bash
# Make sure everything is committed
git add .
git commit -m "chore: prepare for release"

# Create and push tag (replace 0.1.0 with your version)
git tag -a v0.1.1 -m "Release v0.1.1"
git push origin v0.1.1
```

## 🔄 Step 4: Monitor the Publishing Process

After creating a tag, the automation will:

1. **🧪 Run Tests**: Automated testing and code quality checks
2. **📦 Publish to pub.dev**: Automatic package publishing
3. **📝 Create GitHub Release**: Release notes with changelog

### Monitor Progress:

- **GitHub Actions**: https://github.com/Kidpech-code/cache_manager_lite/actions
- **pub.dev Package**: https://pub.dev/packages/cache_manager_lite

## 📊 What the Workflow Does

### Automatic Triggers:

- ✅ **Git Tag Push**: `v*.*.*` (e.g., v0.1.1, v0.1.1)
- ✅ **Manual Trigger**: Can be run manually with version input

### Workflow Steps:

1. **Testing Job**:

   - ✅ Code formatting check
   - ✅ Static analysis
   - ✅ Unit tests
   - ✅ Publish dry-run validation

2. **Publishing Job** (only for tags):

   - ✅ Set up Flutter environment
   - ✅ Configure pub.dev credentials
   - ✅ Publish to pub.dev

3. **GitHub Release Job**:
   - ✅ Create release with changelog
   - ✅ Multi-language documentation links
   - ✅ Installation instructions

## 🚨 Troubleshooting

### Publishing Fails:

1. **Check Secrets**: Ensure all 4 pub.dev secrets are correctly set
2. **Token Expiry**: Regenerate pub.dev credentials if expired
3. **Version Conflict**: Ensure version doesn't already exist on pub.dev

### Tests Fail:

1. **Local Testing**: Run `flutter test` locally first
2. **Formatting**: Run `dart format .` to fix formatting issues
3. **Analysis**: Run `dart analyze` to fix static analysis issues

### Tag Already Exists:

```bash
# Delete local tag
git tag -d v0.1.1

# Delete remote tag (be careful!)
git push origin --delete v0.1.1

# Create new tag
git tag -a v0.1.1 -m "Release v0.1.1"
git push origin v0.1.1
```

## 🎯 Best Practices

### Version Management:

- ✅ Use semantic versioning (e.g., 0.1.0, 0.1.1, 1.0.0)
- ✅ Update `CHANGELOG.md` before each release
- ✅ Test thoroughly before tagging

### Release Process:

1. ✅ Update documentation if needed
2. ✅ Update `CHANGELOG.md`
3. ✅ Run tests locally: `flutter test`
4. ✅ Check formatting: `dart format .`
5. ✅ Run analysis: `dart analyze`
6. ✅ Dry-run publish: `dart pub publish --dry-run`
7. ✅ Use release script: `./scripts/release.sh`

## 🌐 Multi-language Documentation

Your package includes documentation in 6 languages:

- 🇺🇸 [English](../README.md)
- 🇹🇭 [Thai](../doc/README.th.md)
- 🇨🇳 [Chinese](../doc/README.cn.md)
- 🇲🇲 [Myanmar](../doc/README.mm.md)
- 🇸🇬 [Singapore](../doc/README.sg.md)
- 🇱🇦 [Lao](../doc/README.la.md)

Each release will automatically include links to all language versions.

## 🎉 Success!

Once set up, your publishing workflow will be:

1. **Develop** → Code your features
2. **Test** → `flutter test`
3. **Release** → `./scripts/release.sh`
4. **Automated** → GitHub Actions does the rest!

Your package will be automatically published to pub.dev with professional release notes and multi-language documentation links.

---

**Happy Publishing!** 🚀
