#!/bin/bash

# 🚀 Cache Manager Lite - Production Release Script
# This script helps create production releases (1.0.0+)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Cache Manager Lite - Production Release Helper${NC}"
echo "=================================================="

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: This is not a Git repository${NC}"
    exit 1
fi

# Get current version from pubspec.yaml
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
echo -e "${BLUE}📦 Current version: ${GREEN}$CURRENT_VERSION${NC}"

# Check if current version is pre-release
if [[ ! $CURRENT_VERSION =~ ^0\. ]]; then
    echo -e "${YELLOW}⚠️  Current version is already production (1.0.0+)${NC}"
    echo "Use regular release script for production updates."
    exit 1
fi

echo ""
echo -e "${YELLOW}🎯 Production Release Readiness Check:${NC}"

# Pre-production checklist
echo ""
echo "Before creating a production release, please confirm:"
echo "✅ All features are complete and tested"
echo "✅ Documentation is up-to-date"
echo "✅ API is stable (no breaking changes planned)"
echo "✅ Community feedback has been addressed"
echo "✅ All tests pass consistently"
echo "✅ Performance is acceptable"
echo "✅ Security review completed"
echo ""

read -p "Are you ready for production release? (y/N): " ready
if [[ $ready != [yY] && $ready != [yY][eE][sS] ]]; then
    echo -e "${YELLOW}🚫 Production release cancelled${NC}"
    echo "Continue using pre-release versions (0.x.x) until ready."
    exit 0
fi

echo ""
echo "Choose production version:"
echo "1) 1.0.0 (First stable release)"
echo "2) Custom production version (1.x.x)"
echo "3) Cancel"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        VERSION="1.0.0"
        ;;
    2)
        read -p "Enter production version (e.g., 1.0.0): " VERSION
        if [[ ! $VERSION =~ ^[1-9][0-9]*\.[0-9]+\.[0-9]+$ ]]; then
            echo -e "${RED}❌ Invalid production version. Must be 1.0.0 or higher.${NC}"
            exit 1
        fi
        ;;
    3)
        echo -e "${YELLOW}🚫 Production release cancelled${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

TAG_NAME="v$VERSION"

# Check if tag already exists
if git tag -l | grep -q "^$TAG_NAME$"; then
    echo -e "${RED}❌ Tag $TAG_NAME already exists${NC}"
    exit 1
fi

# Show production release summary
echo ""
echo -e "${GREEN}🎉 Production Release Summary:${NC}"
echo "  • Current: $CURRENT_VERSION (Pre-release)"
echo "  • New: $VERSION (Production)"
echo "  • Tag: $TAG_NAME"
echo "  • Stage: 🚀 PRODUCTION READY"
echo "  • Breaking: Pre-release → Production"
echo ""
echo -e "${YELLOW}⚠️  This will mark your package as production-ready!${NC}"
echo ""

# Final confirmation
read -p "Create production release $VERSION? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo -e "${YELLOW}🚫 Production release cancelled${NC}"
    exit 0
fi

# Update CHANGELOG for production
echo -e "${BLUE}📝 Please update CHANGELOG.md with production release notes...${NC}"
read -p "Press Enter after updating CHANGELOG.md..."

# Pre-flight checks
echo -e "${BLUE}🔍 Running production pre-flight checks...${NC}"

# Check if we have uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${RED}❌ You have uncommitted changes. Please commit them first.${NC}"
    exit 1
fi

# Run comprehensive tests
echo -e "${YELLOW}🧪 Running comprehensive tests...${NC}"
if ! flutter test; then
    echo -e "${RED}❌ Tests failed. Fix before production release.${NC}"
    exit 1
fi

# Check formatting
echo -e "${YELLOW}📐 Checking code formatting...${NC}"
if ! dart format --output=none --set-exit-if-changed .; then
    echo -e "${RED}❌ Code formatting issues found.${NC}"
    exit 1
fi

# Run static analysis
echo -e "${YELLOW}🔍 Running static analysis...${NC}"
if ! dart analyze --fatal-infos; then
    echo -e "${RED}❌ Static analysis failed.${NC}"
    exit 1
fi

# Check publish dry-run
echo -e "${YELLOW}📦 Validating package for production...${NC}"
if ! dart pub publish --dry-run; then
    echo -e "${RED}❌ Package validation failed.${NC}"
    exit 1
fi

# Update version
echo -e "${YELLOW}📝 Updating to production version $VERSION...${NC}"
sed -i.bak "s/^version:.*/version: $VERSION/" pubspec.yaml
rm pubspec.yaml.bak

# Commit the production version
git add pubspec.yaml
git commit -m "feat: release production version $VERSION

🚀 This marks the first stable production release!

BREAKING CHANGE: Transition from pre-release (0.x.x) to production (1.x.x)
- API is now stable and follows semantic versioning
- Ready for production use
- Breaking changes will increment major version"

# Create and push production tag
echo -e "${YELLOW}🏷️  Creating production tag $TAG_NAME...${NC}"
git tag -a "$TAG_NAME" -m "🚀 Production Release $TAG_NAME

## 🎉 First Stable Release!

This marks the transition from pre-release to production-ready package.

### 🌟 What's New in Production:
- ✅ Stable API (semantic versioning)
- ✅ Production-ready codebase
- ✅ Comprehensive testing
- ✅ Complete documentation
- ✅ Multi-language support (6 languages)

### 📦 Installation
\`\`\`yaml
dependencies:
  cache_manager_lite: ^$VERSION
\`\`\`

### 🌐 Documentation
- English: https://github.com/Kidpech-code/cache_manager_lite#readme
- Thai: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.th.md
- Chinese: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.cn.md
- Myanmar: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.mm.md
- Singapore: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.sg.md
- Lao: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.la.md

### 🚀 Production Features:
- Multiple user levels (Beginner, Intermediate, Advanced)
- Flexible expiration strategies
- AES encryption support
- Real-time monitoring
- Offline-first capabilities
- Clean Architecture with DDD
- Multi-platform support

### 🎯 What's Next:
- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Breaking changes will increment major version
- New features increment minor version
- Bug fixes increment patch version"

echo -e "${YELLOW}🚀 Pushing production tag to GitHub...${NC}"
git push origin "$TAG_NAME"

echo ""
echo -e "${GREEN}🎉 SUCCESS! Production Release $TAG_NAME created!${NC}"
echo ""
echo -e "${BLUE}📋 What happens next:${NC}"
echo "  1. 🔄 GitHub Actions will automatically:"
echo "     • Run comprehensive tests"
echo "     • Publish to pub.dev as STABLE"
echo "     • Create GitHub release with production notes"
echo ""
echo "  2. 📱 Monitor at:"
echo "     • GitHub Actions: https://github.com/Kidpech-code/cache_manager_lite/actions"
echo "     • pub.dev: https://pub.dev/packages/cache_manager_lite"
echo ""
echo -e "${GREEN}🚀 Welcome to Production! 🎉${NC}"
