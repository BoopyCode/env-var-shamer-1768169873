#!/bin/bash
# EnvVar Shamer - Because your secrets deserve public humiliation

# Colors for maximum shame effect
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Common secret patterns - the usual suspects
PATTERNS=(
    "API_KEY"
    "SECRET"
    "PASSWORD"
    "TOKEN"
    "PRIVATE_KEY"
    "AWS_ACCESS"
    "DATABASE_URL"
    "CREDENTIAL"
)

# Files to check (because .env in git is a cry for help)
FILES=("*.env" "*.env.*" "config/*" "*.config" "*.json" "*.yaml" "*.yml" "*.txt")

# The shame-o-meter
SHAME_LEVEL=0

# Welcome to your intervention
printf "${YELLOW}🔍 EnvVar Shamer - Scanning for shameful commits...${NC}\n\n"

# Check each file pattern
for pattern in "${FILES[@]}"; do
    for file in $(find . -name "$pattern" -type f 2>/dev/null); do
        printf "Checking: %s\n" "$file"
        
        # Look for naughty patterns
        for pattern in "${PATTERNS[@]}"; do
            if grep -qi "$pattern" "$file" 2>/dev/null; then
                printf "${RED}  ✗ Found '%s' in %s${NC}\n" "$pattern" "$file"
                SHAME_LEVEL=$((SHAME_LEVEL + 1))
            fi
        done
    done
done

# The verdict
printf "\n${YELLOW}=== SHAME REPORT ===${NC}\n"
if [ $SHAME_LEVEL -eq 0 ]; then
    printf "${YELLOW}🎉 No secrets found! You're... adequate.${NC}\n"
else
    printf "${RED}🔥 Found %d potential secrets! Your commit history is blushing.${NC}\n" "$SHAME_LEVEL"
    printf "${YELLOW}💡 Tip: Use .gitignore and actual environment variables next time!${NC}\n"
fi

# Optional: Check git history for past sins
printf "\n${YELLOW}Want to check git history for old secrets? (y/n): ${NC}"
read -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "\n${YELLOW}🔍 Digging up past mistakes...${NC}\n"
    for pattern in "${PATTERNS[@]}"; do
        if git log -p --all 2>/dev/null | grep -qi "$pattern"; then
            printf "${RED}  ✗ Found '%s' in git history! The shame is eternal.${NC}\n" "$pattern"
        fi
done
fi

printf "\n${YELLOW}Shame level: %d/10${NC}\n" "$((SHAME_LEVEL > 10 ? 10 : SHAME_LEVEL))"
