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

# Function to increment version
increment_version() {
    local version=$1
    local type=$2
    
    IFS='.' read -ra PARTS <<< "$version"
    major=${PARTS[0]}
    minor=${PARTS[1]}
    patch=${PARTS[2]}
    
    case $type in
        "patch")
            if [ $patch -eq 9 ]; then
                patch=0
                minor=$((minor + 1))
                if [ $minor -eq 10 ]; then
                    minor=0
                    major=$((major + 1))
                fi
            else
                patch=$((patch + 1))
            fi
            ;;
        "minor")
            patch=0
            minor=$((minor + 1))
            if [ $minor -eq 10 ]; then
                minor=0
                major=$((major + 1))
            fi
            ;;
        "major")
            patch=0
            minor=0
            major=$((major + 1))
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Calculate next versions
NEXT_PATCH=$(increment_version $CURRENT_VERSION "patch")
NEXT_MINOR=$(increment_version $CURRENT_VERSION "minor") 
NEXT_MAJOR=$(increment_version $CURRENT_VERSION "major")

# Determine version type
if [[ $CURRENT_VERSION =~ ^0\. ]]; then
    VERSION_TYPE="🧪 Pre-release"
    PRODUCTION_VERSION="1.0.0"
else
    VERSION_TYPE="🚀 Production"
    PRODUCTION_VERSION=""
fi

# Ask for confirmation or new version
echo ""
echo -e "${BLUE}Current: ${GREEN}$CURRENT_VERSION${NC} ($VERSION_TYPE)"
echo ""
echo "Choose release type:"
echo "1) Patch release: $CURRENT_VERSION → $NEXT_PATCH (Bug fixes)"
echo "2) Minor release: $CURRENT_VERSION → $NEXT_MINOR (New features)"
echo "3) Major release: $CURRENT_VERSION → $NEXT_MAJOR (Breaking changes)"
if [[ -n $PRODUCTION_VERSION ]]; then
echo "4) Production release: $CURRENT_VERSION → $PRODUCTION_VERSION (Ready for production)"
fi
echo "5) Custom version"
echo "6) Release current version ($CURRENT_VERSION)"
echo "7) Cancel"
echo ""
read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        VERSION=$NEXT_PATCH
        RELEASE_TYPE="patch"
        ;;
    2)
        VERSION=$NEXT_MINOR
        RELEASE_TYPE="minor"
        ;;
    3)
        VERSION=$NEXT_MAJOR
        RELEASE_TYPE="major"
        ;;
    4)
        if [[ -n $PRODUCTION_VERSION ]]; then
            VERSION=$PRODUCTION_VERSION
            RELEASE_TYPE="production"
        else
            echo -e "${RED}❌ Invalid choice${NC}"
            exit 1
        fi
        ;;
    5)
        read -p "Enter custom version (e.g., 0.1.1): " VERSION
        if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-.*)?$ ]]; then
            echo -e "${RED}❌ Invalid version format. Use semantic versioning (e.g., 0.1.1)${NC}"
            exit 1
        fi
        RELEASE_TYPE="custom"
        ;;
    6)
        VERSION=$CURRENT_VERSION
        RELEASE_TYPE="current"
        ;;
    7)
        echo -e "${YELLOW}🚫 Release cancelled${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

# Update version if needed
if [[ $VERSION != $CURRENT_VERSION ]]; then
    echo -e "${YELLOW}📝 Updating pubspec.yaml to version $VERSION...${NC}"
    sed -i.bak "s/^version:.*/version: $VERSION/" pubspec.yaml
    rm pubspec.yaml.bak
    
    # Update all documentation files with new version
    echo -e "${YELLOW}📚 Updating documentation files to version $VERSION...${NC}"
    ./scripts/update-version.sh $VERSION
    
    # Stage all updated files
    git add .
    
    # Commit the version change
    git commit -m "chore: bump version to $VERSION ($RELEASE_TYPE release)

- Updated pubspec.yaml to version $VERSION
- Updated all documentation files to reflect new version
- Updated CHANGELOG.md with new version entry"
fi

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
echo "  • Type: $RELEASE_TYPE release"
if [[ $VERSION =~ ^0\. ]]; then
    echo "  • Stage: 🧪 Pre-release (Development/Testing)"
else
    echo "  • Stage: 🚀 Production (Stable)"
fi
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
