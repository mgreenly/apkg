#!/bin/bash
# Generate manifest.json by scanning agents directory structure

set -euo pipefail

# Repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="$REPO_ROOT/agents"
MANIFEST_FILE="$REPO_ROOT/manifest.json"

# Check if agents directory exists
if [[ ! -d "$AGENTS_DIR" ]]; then
    echo "Error: agents directory not found at $AGENTS_DIR" >&2
    exit 1
fi

# Initialize associative array to collect packages
declare -A packages

# Function to get base name without extension
get_basename() {
    local filename="$1"
    echo "${filename%.*}"
}

# Scan skills directory
if [[ -d "$AGENTS_DIR/skills" ]]; then
    for file in "$AGENTS_DIR/skills"/*.md; do
        [[ -e "$file" ]] || continue
        basename=$(basename "$file")
        name=$(get_basename "$basename")
        packages["$name"]=1
    done
fi

# Scan scripts directory
if [[ -d "$AGENTS_DIR/scripts" ]]; then
    for file in "$AGENTS_DIR/scripts"/*.ts; do
        [[ -e "$file" ]] || continue
        basename=$(basename "$file")
        name=$(get_basename "$basename")
        packages["$name"]=1
    done
fi

# Scan commands directory
if [[ -d "$AGENTS_DIR/commands" ]]; then
    for file in "$AGENTS_DIR/commands"/*.md; do
        [[ -e "$file" ]] || continue
        basename=$(basename "$file")
        name=$(get_basename "$basename")
        packages["$name"]=1
    done
fi

# Build JSON output
echo "{" > "$MANIFEST_FILE"
echo '  "packages": [' >> "$MANIFEST_FILE"

first=true
for package_name in $(echo "${!packages[@]}" | tr ' ' '\n' | sort); do
    # Skip if package name is README
    if [[ "$package_name" == "README" ]]; then
        continue
    fi

    # Add comma for all but first entry
    if [[ "$first" == "true" ]]; then
        first=false
    else
        echo "," >> "$MANIFEST_FILE"
    fi

    # Start package entry
    echo "    {" >> "$MANIFEST_FILE"
    echo "      \"name\": \"$package_name\"," >> "$MANIFEST_FILE"

    # Collect parts
    parts_added=false

    # Check for skills
    if [[ -f "$AGENTS_DIR/skills/$package_name.md" ]]; then
        if [[ "$parts_added" == "true" ]]; then
            echo "," >> "$MANIFEST_FILE"
        fi
        echo "      \"skills\": [\"$package_name.md\"]" >> "$MANIFEST_FILE"
        parts_added=true
    fi

    # Check for scripts
    if [[ -f "$AGENTS_DIR/scripts/$package_name.ts" ]]; then
        if [[ "$parts_added" == "true" ]]; then
            echo "," >> "$MANIFEST_FILE"
        fi
        echo "      \"scripts\": [\"$package_name.ts\"]" >> "$MANIFEST_FILE"
        parts_added=true
    fi

    # Check for commands
    if [[ -f "$AGENTS_DIR/commands/$package_name.md" ]]; then
        if [[ "$parts_added" == "true" ]]; then
            echo "," >> "$MANIFEST_FILE"
        fi
        echo "      \"commands\": [\"$package_name.md\"]" >> "$MANIFEST_FILE"
        parts_added=true
    fi

    # Close package entry (no trailing comma)
    echo -n "    }" >> "$MANIFEST_FILE"
done

# Close JSON
echo "" >> "$MANIFEST_FILE"
echo "  ]" >> "$MANIFEST_FILE"
echo "}" >> "$MANIFEST_FILE"

echo "Manifest generated successfully at $MANIFEST_FILE" >&2
