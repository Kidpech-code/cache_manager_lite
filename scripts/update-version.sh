#!/bin/bash

# 🔄 Cache Manager Lite - Version Update Script
# This script updates version numbers across all documentation files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Cache Manager Lite - Version Update Helper${NC}"
echo "================================================"

# Check if version parameter is provided
if [ -z "$1" ]; then
    # Get current version from pubspec.yaml
    CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
    echo -e "${BLUE}📦 Current version in pubspec.yaml: ${GREEN}$CURRENT_VERSION${NC}"
    echo ""
    
    read -p "Enter new version to update all documentation (e.g., 0.1.1): " NEW_VERSION
    if [[ -z $NEW_VERSION ]]; then
        echo -e "${RED}❌ Version cannot be empty${NC}"
        exit 1
    fi
else
    CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
    NEW_VERSION=$1
fi

# Validate version format
if [[ ! $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-.*)?$ ]]; then
    echo -e "${RED}❌ Invalid version format. Use semantic versioning (e.g., 0.1.1)${NC}"
    exit 1
fi

echo -e "${YELLOW}🔄 Updating from version ${RED}$CURRENT_VERSION${YELLOW} to ${GREEN}$NEW_VERSION${NC}"
echo ""

# Function to update version in file
update_version_in_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo -e "  📝 Updating $description..."
        
        # Update cache_manager_lite: ^X.X.X patterns
        sed -i.bak "s/cache_manager_lite: \^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/cache_manager_lite: ^$NEW_VERSION/g" "$file"
        
        # Update version tags and references
        sed -i.bak "s/v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/v$NEW_VERSION/g" "$file"
        
        # Update CHANGELOG version pattern
        if [[ "$file" == *"CHANGELOG.md" ]]; then
            sed -i.bak "s/## \[[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\]/## [$NEW_VERSION]/g" "$file"
        fi
        
        # Clean up backup files
        rm -f "$file.bak"
        
        echo -e "    ${GREEN}✅ Updated${NC}"
    else
        echo -e "    ${YELLOW}⚠️  File not found: $file${NC}"
    fi
}

# Update main README files
update_version_in_file "README.md" "Main README"
update_version_in_file "README_NEW.md" "New README"

# Update documentation files
update_version_in_file "doc/README.th.md" "Thai README"
update_version_in_file "doc/README.cn.md" "Chinese README"
update_version_in_file "doc/README.mm.md" "Myanmar README"
update_version_in_file "doc/README.sg.md" "Singapore README"
update_version_in_file "doc/README.la.md" "Lao README"

# Update guide files
update_version_in_file "GETTING_STARTED.md" "Getting Started Guide"
update_version_in_file "DOCUMENTATION_GUIDE.md" "Documentation Guide"
update_version_in_file "USER_LEVEL_GUIDE.md" "User Level Guide"
update_version_in_file "EXPIRATION_GUIDE.md" "Expiration Guide"

# Update automation files
update_version_in_file "AUTOMATION_SETUP.md" "Automation Setup Guide"
update_version_in_file "PUBLICATION_CHECKLIST.md" "Publication Checklist"

# Update CHANGELOG (special handling)
if [ -f "CHANGELOG.md" ]; then
    echo -e "  📝 Updating CHANGELOG.md..."
    
    # Get current date
    CURRENT_DATE=$(date +%Y-%m-%d)
    
    # Add new version entry at the top
    if ! grep -q "## \[$NEW_VERSION\]" CHANGELOG.md; then
        # Create temporary file with new entry
        echo "## [$NEW_VERSION] - $CURRENT_DATE" > temp_changelog.md
        echo "" >> temp_changelog.md
        echo "### Added" >> temp_changelog.md
        echo "- Version bump to $NEW_VERSION" >> temp_changelog.md
        echo "" >> temp_changelog.md
        
        # Append existing content
        cat CHANGELOG.md >> temp_changelog.md
        
        # Replace original file
        mv temp_changelog.md CHANGELOG.md
        
        echo -e "    ${GREEN}✅ Added new version entry${NC}"
    else
        echo -e "    ${YELLOW}⚠️  Version $NEW_VERSION already exists in CHANGELOG${NC}"
    fi
fi

# Update examples if they exist
if [ -d "example" ]; then
    echo -e "  📝 Updating example files..."
    find example -name "*.dart" -o -name "*.md" -o -name "pubspec.yaml" | while read -r file; do
        if [ -f "$file" ]; then
            sed -i.bak "s/cache_manager_lite: \^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/cache_manager_lite: ^$NEW_VERSION/g" "$file"
            rm -f "$file.bak"
        fi
    done
    echo -e "    ${GREEN}✅ Updated example files${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Version update completed!${NC}"
echo ""
echo -e "${BLUE}📋 Updated files:${NC}"
echo "  • README.md and translations (6 languages)"
echo "  • Documentation guides"
echo "  • CHANGELOG.md (added new entry)"
echo "  • Automation setup files"
echo "  • Example files"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "1. Review the updated files"
echo "2. Update CHANGELOG.md with actual changes"
echo "3. Commit the changes"
echo "4. Use ./scripts/release.sh to create a release"
echo ""
echo -e "${GREEN}✨ All documentation is now consistent with version $NEW_VERSION!${NC}"
