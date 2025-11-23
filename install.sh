#!/bin/sh
#
# apkg bootstrap installer
# Usage: curl -fsSL https://raw.githubusercontent.com/mgreenly/apkg/HEAD/install.sh | sh
#

set -e

# Color codes for output
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    GREEN=''
    YELLOW=''
    RED=''
    BLUE=''
    NC=''
fi

# Variables
AGENTS_DIR=".agents"
APKG_URL="https://raw.githubusercontent.com/mgreenly/apkg/HEAD/agents/scripts/apkg.ts"
APKG_DEST="${AGENTS_DIR}/scripts/apkg.ts"

# Track what was created
CREATED_ITEMS=""
SKIPPED_ITEMS=""
DOWNLOADED_ITEMS=""

# Helper functions
log_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

log_success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

log_warning() {
    printf "${YELLOW}[SKIP]${NC} %s\n" "$1"
}

log_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
}

# Check for required tools
check_requirements() {
    if ! command -v curl >/dev/null 2>&1; then
        log_error "curl is required but not installed. Please install curl and try again."
        exit 1
    fi
}

# Create directory if it doesn't exist
create_directory() {
    dir="$1"
    if [ -d "$dir" ]; then
        log_warning "Directory already exists: $dir"
        SKIPPED_ITEMS="${SKIPPED_ITEMS}  - $dir\n"
    else
        mkdir -p "$dir"
        log_success "Created directory: $dir"
        CREATED_ITEMS="${CREATED_ITEMS}  - $dir\n"
    fi
}

# Download file if it doesn't exist
download_file() {
    url="$1"
    dest="$2"

    if [ -f "$dest" ]; then
        log_warning "File already exists: $dest"
        SKIPPED_ITEMS="${SKIPPED_ITEMS}  - $dest\n"
        return 0
    fi

    log_info "Downloading: $dest"
    if curl -fsSL "$url" -o "$dest"; then
        log_success "Downloaded: $dest"
        DOWNLOADED_ITEMS="${DOWNLOADED_ITEMS}  - $dest\n"
    else
        log_error "Failed to download: $url"
        log_error "Please check your internet connection and try again."
        return 1
    fi
}

# Main installation
main() {
    log_info "Starting apkg bootstrap installation..."
    echo ""

    # Check requirements
    check_requirements

    # Create directory structure
    log_info "Creating .agents directory structure..."
    create_directory "${AGENTS_DIR}"
    create_directory "${AGENTS_DIR}/commands"
    create_directory "${AGENTS_DIR}/skills"
    create_directory "${AGENTS_DIR}/scripts"
    echo ""

    # Download apkg.ts
    log_info "Downloading apkg.ts..."
    if ! download_file "$APKG_URL" "$APKG_DEST"; then
        exit 1
    fi
    echo ""

    # Print summary
    printf "${GREEN}================================${NC}\n"
    printf "${GREEN}Installation Complete!${NC}\n"
    printf "${GREEN}================================${NC}\n"
    echo ""

    if [ -n "$CREATED_ITEMS" ]; then
        printf "${GREEN}Created:${NC}\n"
        printf "$CREATED_ITEMS"
        echo ""
    fi

    if [ -n "$DOWNLOADED_ITEMS" ]; then
        printf "${GREEN}Downloaded:${NC}\n"
        printf "$DOWNLOADED_ITEMS"
        echo ""
    fi

    if [ -n "$SKIPPED_ITEMS" ]; then
        printf "${YELLOW}Skipped (already exists):${NC}\n"
        printf "$SKIPPED_ITEMS"
        echo ""
    fi

    # Print verification steps
    printf "${BLUE}================================${NC}\n"
    printf "${BLUE}Manual Verification Steps${NC}\n"
    printf "${BLUE}================================${NC}\n"
    echo ""
    echo "To verify the installation was successful, run these commands:"
    echo ""
    echo "  1. Check directory structure:"
    echo "     ls -la ${AGENTS_DIR}/"
    echo ""
    echo "  2. Verify subdirectories exist:"
    echo "     ls -la ${AGENTS_DIR}/commands ${AGENTS_DIR}/skills ${AGENTS_DIR}/scripts"
    echo ""
    echo "  3. Confirm apkg.ts was downloaded:"
    echo "     ls -lh ${APKG_DEST}"
    echo ""
    echo "  4. Check apkg.ts is executable (if needed):"
    echo "     file ${APKG_DEST}"
    echo ""
    echo "  5. Test apkg.ts (requires Deno):"
    echo "     deno run --allow-read ${APKG_DEST} --help"
    echo ""
    printf "${GREEN}Installation successful!${NC}\n"
}

# Run main function
main
