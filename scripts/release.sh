#!/bin/bash

# 🚀 Cache Manager Lite - Automated Release Script
# This script helps create Git tags and trigger automated publishing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Cache Manager Lite - Release Helper${NC}"
echo "========================================"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: This is not a Git repository${NC}"
    exit 1
fi

# Get current version from pubspec.yaml
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
echo -e "${BLUE}📦 Current version in pubspec.yaml: ${GREEN}$CURRENT_VERSION${NC}"

# Ask for confirmation or new version
echo ""
echo "Choose an option:"
echo "1) Release current version ($CURRENT_VERSION)"
echo "2) Specify a different version"
echo "3) Cancel"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        VERSION=$CURRENT_VERSION
        ;;
    2)
        read -p "Enter new version (e.g., 0.1.1): " VERSION
        if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-.*)?$ ]]; then
            echo -e "${RED}❌ Invalid version format. Use semantic versioning (e.g., 0.1.1)${NC}"
            exit 1
        fi
        
        # Update pubspec.yaml
        echo -e "${YELLOW}📝 Updating pubspec.yaml to version $VERSION...${NC}"
        sed -i.bak "s/^version:.*/version: $VERSION/" pubspec.yaml
        rm pubspec.yaml.bak
        
        # Commit the version change
        git add pubspec.yaml
        git commit -m "chore: bump version to $VERSION"
        ;;
    3)
        echo -e "${YELLOW}🚫 Release cancelled${NC}"
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

# Show what will happen
echo ""
echo -e "${YELLOW}📋 Release Summary:${NC}"
echo "  • Version: $VERSION"
echo "  • Tag: $TAG_NAME"
echo "  • Will trigger automated publishing to pub.dev"
echo "  • Will create GitHub release"
echo ""

# Final confirmation
read -p "Do you want to proceed? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo -e "${YELLOW}🚫 Release cancelled${NC}"
    exit 0
fi

# Pre-flight checks
echo -e "${BLUE}🔍 Running pre-flight checks...${NC}"

# Check if we have uncommitted changes (except for version bump we just made)
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${RED}❌ You have uncommitted changes. Please commit or stash them first.${NC}"
    exit 1
fi

# Run tests
echo -e "${YELLOW}🧪 Running tests...${NC}"
if ! flutter test; then
    echo -e "${RED}❌ Tests failed. Please fix them before releasing.${NC}"
    exit 1
fi

# Check formatting
echo -e "${YELLOW}📐 Checking code formatting...${NC}"
if ! dart format --output=none --set-exit-if-changed .; then
    echo -e "${RED}❌ Code is not properly formatted. Run 'dart format .' first.${NC}"
    exit 1
fi

# Run static analysis
echo -e "${YELLOW}🔍 Running static analysis...${NC}"
if ! dart analyze --fatal-infos; then
    echo -e "${RED}❌ Static analysis failed. Please fix the issues first.${NC}"
    exit 1
fi

# Check publish dry-run
echo -e "${YELLOW}📦 Checking package for publishing...${NC}"
if ! dart pub publish --dry-run; then
    echo -e "${RED}❌ Package validation failed. Please fix the issues first.${NC}"
    exit 1
fi

# Create and push tag
echo -e "${YELLOW}🏷️  Creating tag $TAG_NAME...${NC}"
git tag -a "$TAG_NAME" -m "Release $TAG_NAME

## 🚀 What's New in $VERSION
- See CHANGELOG.md for detailed changes

## 📦 Installation
\`\`\`yaml
dependencies:
  cache_manager_lite: ^$VERSION
\`\`\`

## 🌐 Documentation
- English: https://github.com/Kidpech-code/cache_manager_lite#readme
- Thai: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.th.md
- Chinese: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.cn.md
- Myanmar: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.mm.md
- Singapore: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.sg.md
- Lao: https://github.com/Kidpech-code/cache_manager_lite/blob/main/doc/README.la.md"

echo -e "${YELLOW}🚀 Pushing tag to GitHub...${NC}"
git push origin "$TAG_NAME"

echo ""
echo -e "${GREEN}✅ Success! Release $TAG_NAME created and pushed.${NC}"
echo ""
echo -e "${BLUE}📋 What happens next:${NC}"
echo "  1. 🔄 GitHub Actions will automatically:"
echo "     • Run tests and static analysis"
echo "     • Publish to pub.dev"
echo "     • Create GitHub release"
echo ""
echo "  2. 📱 Monitor the progress at:"
echo "     • GitHub Actions: https://github.com/Kidpech-code/cache_manager_lite/actions"
echo "     • pub.dev: https://pub.dev/packages/cache_manager_lite"
echo ""
echo -e "${GREEN}🎉 Happy publishing!${NC}"
