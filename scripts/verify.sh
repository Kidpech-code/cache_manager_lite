#!/bin/bash

# 🔍 Pre-Release Verification Script
# This script verifies that everything is ready for automated publishing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Cache Manager Lite - Pre-Release Verification${NC}"
echo "=================================================="

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print check result
print_check() {
    if [ $1 -eq 0 ]; then
        echo -e "  ${GREEN}✅ $2${NC}"
    else
        echo -e "  ${RED}❌ $2${NC}"
        return 1
    fi
}

echo -e "${YELLOW}📋 Checking Prerequisites...${NC}"

# Check Flutter installation
if command_exists flutter; then
    FLUTTER_VERSION=$(flutter --version | head -n1)
    print_check 0 "Flutter installed: $FLUTTER_VERSION"
else
    print_check 1 "Flutter is not installed"
    exit 1
fi

# Check Dart installation
if command_exists dart; then
    DART_VERSION=$(dart --version 2>&1 | head -n1)
    print_check 0 "Dart installed: $DART_VERSION"
else
    print_check 1 "Dart is not installed"
    exit 1
fi

# Check Git installation
if command_exists git; then
    GIT_VERSION=$(git --version)
    print_check 0 "Git installed: $GIT_VERSION"
else
    print_check 1 "Git is not installed"
    exit 1
fi

echo ""
echo -e "${YELLOW}📦 Checking Package Configuration...${NC}"

# Check pubspec.yaml
if [ -f "pubspec.yaml" ]; then
    print_check 0 "pubspec.yaml exists"
    
    # Check required fields
    if grep -q "^name:" pubspec.yaml; then
        print_check 0 "Package name is defined"
    else
        print_check 1 "Package name is missing"
    fi
    
    if grep -q "^version:" pubspec.yaml; then
        VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
        print_check 0 "Version is defined: $VERSION"
    else
        print_check 1 "Version is missing"
    fi
    
    if grep -q "^description:" pubspec.yaml; then
        print_check 0 "Description is defined"
    else
        print_check 1 "Description is missing"
    fi
    
    if grep -q "^homepage:" pubspec.yaml; then
        print_check 0 "Homepage is defined"
    else
        print_check 1 "Homepage is missing"
    fi
    
    if grep -q "^repository:" pubspec.yaml; then
        print_check 0 "Repository is defined"
    else
        print_check 1 "Repository is missing"
    fi
    
    if grep -q "^issue_tracker:" pubspec.yaml; then
        print_check 0 "Issue tracker is defined"
    else
        print_check 1 "Issue tracker is missing"
    fi
else
    print_check 1 "pubspec.yaml not found"
    exit 1
fi

# Check LICENSE
if [ -f "LICENSE" ]; then
    print_check 0 "LICENSE file exists"
else
    print_check 1 "LICENSE file is missing"
fi

# Check CHANGELOG
if [ -f "CHANGELOG.md" ]; then
    print_check 0 "CHANGELOG.md exists"
else
    print_check 1 "CHANGELOG.md is missing"
fi

# Check README
if [ -f "README.md" ]; then
    print_check 0 "README.md exists"
else
    print_check 1 "README.md is missing"
fi

echo ""
echo -e "${YELLOW}🌐 Checking Internationalization...${NC}"

# Check documentation files
DOC_FILES=("README.th.md" "README.cn.md" "README.mm.md" "README.sg.md" "README.la.md")
for file in "${DOC_FILES[@]}"; do
    if [ -f "doc/$file" ]; then
        print_check 0 "doc/$file exists"
    else
        print_check 1 "doc/$file is missing"
    fi
done

echo ""
echo -e "${YELLOW}🔧 Checking Automation Setup...${NC}"

# Check GitHub Actions workflow
if [ -f ".github/workflows/publish.yml" ]; then
    print_check 0 "GitHub Actions workflow exists"
else
    print_check 1 "GitHub Actions workflow is missing"
fi

# Check release script
if [ -f "scripts/release.sh" ]; then
    if [ -x "scripts/release.sh" ]; then
        print_check 0 "Release script exists and is executable"
    else
        print_check 1 "Release script exists but is not executable"
    fi
else
    print_check 1 "Release script is missing"
fi

# Check automation setup guide
if [ -f "AUTOMATION_SETUP.md" ]; then
    print_check 0 "Automation setup guide exists"
else
    print_check 1 "Automation setup guide is missing"
fi

echo ""
echo -e "${YELLOW}🧪 Running Code Quality Checks...${NC}"

# Install dependencies
echo -e "${BLUE}📥 Installing dependencies...${NC}"
if flutter pub get > /dev/null 2>&1; then
    print_check 0 "Dependencies installed successfully"
else
    print_check 1 "Failed to install dependencies"
    exit 1
fi

# Check formatting
echo -e "${BLUE}📐 Checking code formatting...${NC}"
if dart format --output=none --set-exit-if-changed . > /dev/null 2>&1; then
    print_check 0 "Code is properly formatted"
else
    print_check 1 "Code formatting issues found"
    echo -e "  ${YELLOW}💡 Run 'dart format .' to fix formatting${NC}"
fi

# Check static analysis
echo -e "${BLUE}🔍 Running static analysis...${NC}"
if dart analyze --fatal-infos > /dev/null 2>&1; then
    print_check 0 "Static analysis passed"
else
    print_check 1 "Static analysis issues found"
    echo -e "  ${YELLOW}💡 Run 'dart analyze' to see issues${NC}"
fi

# Check tests
echo -e "${BLUE}🧪 Running tests...${NC}"
if flutter test > /dev/null 2>&1; then
    print_check 0 "All tests passed"
else
    print_check 1 "Some tests failed"
    echo -e "  ${YELLOW}💡 Run 'flutter test' to see failing tests${NC}"
fi

# Check publish dry-run
echo -e "${BLUE}📦 Checking package for publishing...${NC}"
if dart pub publish --dry-run > /dev/null 2>&1; then
    print_check 0 "Package is ready for publishing (0 warnings)"
else
    print_check 1 "Package has publishing issues"
    echo -e "  ${YELLOW}💡 Run 'dart pub publish --dry-run' to see issues${NC}"
fi

echo ""
echo -e "${YELLOW}🔑 Checking Git Repository...${NC}"

# Check if we're in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    print_check 0 "Git repository initialized"
    
    # Check for uncommitted changes
    if [ -z "$(git status --porcelain)" ]; then
        print_check 0 "No uncommitted changes"
    else
        print_check 1 "You have uncommitted changes"
        echo -e "  ${YELLOW}💡 Commit your changes before releasing${NC}"
    fi
    
    # Check remote origin
    if git remote get-url origin > /dev/null 2>&1; then
        REMOTE_URL=$(git remote get-url origin)
        print_check 0 "Remote origin configured: $REMOTE_URL"
    else
        print_check 1 "Remote origin is not configured"
    fi
else
    print_check 1 "Not a Git repository"
fi

echo ""
echo -e "${BLUE}📋 Summary${NC}"
echo "========"

if dart pub publish --dry-run > /dev/null 2>&1 && \
   dart analyze --fatal-infos > /dev/null 2>&1 && \
   flutter test > /dev/null 2>&1 && \
   [ -f ".github/workflows/publish.yml" ] && \
   [ -x "scripts/release.sh" ]; then
    
    echo -e "${GREEN}🎉 Everything looks good! Your package is ready for automated publishing.${NC}"
    echo ""
    echo -e "${BLUE}🚀 Next steps:${NC}"
    echo "1. Set up GitHub secrets (see AUTOMATION_SETUP.md)"
    echo "2. Run './scripts/release.sh' to create your first release"
    echo ""
    echo -e "${GREEN}✨ Happy publishing!${NC}"
else
    echo -e "${YELLOW}⚠️  Some issues were found. Please fix them before publishing.${NC}"
    echo ""
    echo -e "${BLUE}🔧 Quick fixes:${NC}"
    echo "• Run 'dart format .' for formatting"
    echo "• Run 'dart analyze' for static analysis issues"
    echo "• Run 'flutter test' for test failures"
    echo "• Run 'dart pub publish --dry-run' for publishing issues"
fi
