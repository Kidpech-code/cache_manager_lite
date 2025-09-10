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
- 🔄 Provides smart version increment options (patch/minor/major/production)
- 📚 Automatically updates all documentation files to new version
- 🧪 Runs comprehensive pre-flight checks
- 🏷️ Creates and pushes Git tags
- 🚀 Triggers automated publishing via GitHub Actions

**Version increment logic:**

- **Patch**: 0.1.0 → 0.1.1 (bug fixes)
- **Minor**: 0.1.9 → 0.2.0 (new features)
- **Major**: 0.9.0 → 1.0.0 (breaking changes)
- **Production**: 0.x.x → 1.0.0 (first stable release)

**When to use:** When you're ready to publish a new version.

---

### 🔄 `update-version.sh`

**Version synchronization script**

```bash
./scripts/update-version.sh [version]
```

**What it does:**

- 📝 Updates version numbers across ALL documentation files
- 🌐 Synchronizes 6 language documentation files
- 📚 Updates guides and setup files
- 📋 Adds new CHANGELOG entry
- 🔧 Updates example files

**When to use:** Automatically called by `release.sh` or manually when version gets out of sync.

---

### 🏭 `production-release.sh`

**Production release creation script**

```bash
./scripts/production-release.sh
```

**What it does:**

- ⚡ Creates production-ready releases (1.0.0+)
- 🎯 Runs production readiness checklist
- 🚀 Marks transition from pre-release to stable
- 📋 Creates comprehensive production release notes
- 🔄 Updates semantic versioning for production

**When to use:** When transitioning from 0.x.x to 1.0.0+ (production-ready).

---

## 🔄 Typical Workflow

### For Regular Development:

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

### For Production Release:

1. **Complete** all pre-release testing
2. **Run production release**:
   ```bash
   ./scripts/production-release.sh
   ```
3. **Monitor** production deployment

## 🎯 Version Management

The scripts implement smart semantic versioning:

### Pre-release (0.x.x):

- **0.1.0 → 0.1.1**: Patch (bug fixes)
- **0.1.9 → 0.2.0**: Minor (new features)
- **0.9.x → 1.0.0**: Production transition

### Production (1.x.x+):

- **1.0.0 → 1.0.1**: Patch (bug fixes)
- **1.0.x → 1.1.0**: Minor (new features)
- **1.x.x → 2.0.0**: Major (breaking changes)

## 🎯 Quick Commands

```bash
# Make scripts executable (if needed)
chmod +x scripts/*.sh

# Check if everything is ready for release
./scripts/verify.sh

# Create a new pre-release (0.x.x)
./scripts/release.sh

# Update version across all files
./scripts/update-version.sh 0.1.2

# Create production release (1.0.0+)
./scripts/production-release.sh
```

## 📚 Additional Resources

- [Automation Setup Guide](../AUTOMATION_SETUP.md) - Complete setup instructions
- [GitHub Actions Workflow](../.github/workflows/publish.yml) - Automated publishing pipeline
- [Main README](../README.md) - Package documentation

---

**Happy Automating!** 🚀
