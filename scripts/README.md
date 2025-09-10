# 🛠️ Scripts Directory

This directory contains automation scripts for the `cache_manager_lite` package.

## 📜 Available Scripts

### 🔍 `verify.sh`

**Pre-release verification script**

```bash
./scripts/verify.sh
```

**What it does:**

- ✅ Checks all prerequisites (Flutter, Dart, Git)
- ✅ Validates package configuration
- ✅ Verifies internationalization files
- ✅ Checks automation setup
- ✅ Runs code quality checks (formatting, analysis, tests)
- ✅ Validates publishing readiness

**When to use:** Before every release to ensure everything is ready.

---

### 🚀 `release.sh`

**Automated release creation script**

```bash
./scripts/release.sh
```

**What it does:**

- 📋 Shows current version from `pubspec.yaml`
- 🔄 Allows version updates if needed
- 🧪 Runs comprehensive pre-flight checks
- 🏷️ Creates and pushes Git tags
- 🚀 Triggers automated publishing via GitHub Actions

**When to use:** When you're ready to publish a new version.

---

## 🔄 Typical Workflow

1. **Develop** your features
2. **Verify** everything is ready:
   ```bash
   ./scripts/verify.sh
   ```
3. **Release** when satisfied:
   ```bash
   ./scripts/release.sh
   ```
4. **Monitor** GitHub Actions for automated publishing

## 🎯 Quick Commands

```bash
# Make scripts executable (if needed)
chmod +x scripts/*.sh

# Check if everything is ready for release
./scripts/verify.sh

# Create a new release
./scripts/release.sh
```

## 📚 Additional Resources

- [Automation Setup Guide](../AUTOMATION_SETUP.md) - Complete setup instructions
- [GitHub Actions Workflow](../.github/workflows/publish.yml) - Automated publishing pipeline
- [Main README](../README.md) - Package documentation

---

**Happy Automating!** 🚀
