# apkg Bootstrap Guide

## Quick Start

To install apkg, run this one-liner in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/mgreenly/apkg/HEAD/install.sh | sh
```

This will create the `.agents/` directory structure and download the necessary files.

## What the Script Does

The bootstrap script performs the following actions:

1. **Creates directory structure** - Sets up `.agents/` with three subdirectories:
   - `.agents/commands/` - Custom slash commands for CLI
   - `.agents/skills/` - Reusable agent behaviors and workflows
   - `.agents/scripts/` - Automation scripts (TypeScript/Deno)

2. **Downloads apkg.ts** - Fetches the core apkg script from the repository and places it in `.agents/scripts/`

3. **Handles existing files** - If directories or files already exist, they are skipped (not overwritten)

4. **Provides verification steps** - Shows commands you can run to verify the installation

## Expected Output

### Successful Installation (Fresh)

```
[INFO] Starting apkg bootstrap installation...

[INFO] Creating .agents directory structure...
[SUCCESS] Created directory: .agents
[SUCCESS] Created directory: .agents/commands
[SUCCESS] Created directory: .agents/skills
[SUCCESS] Created directory: .agents/scripts

[INFO] Downloading apkg.ts...
[INFO] Downloading: .agents/scripts/apkg.ts
[SUCCESS] Downloaded: .agents/scripts/apkg.ts

================================
Installation Complete!
================================

Created:
  - .agents
  - .agents/commands
  - .agents/skills
  - .agents/scripts

Downloaded:
  - .agents/scripts/apkg.ts
```

### Successful Installation (Existing Files)

```
[INFO] Starting apkg bootstrap installation...

[INFO] Creating .agents directory structure...
[SKIP] Directory already exists: .agents
[SKIP] Directory already exists: .agents/commands
[SKIP] Directory already exists: .agents/skills
[SKIP] Directory already exists: .agents/scripts

[INFO] Downloading apkg.ts...
[SKIP] File already exists: .agents/scripts/apkg.ts

================================
Installation Complete!
================================

Skipped (already exists):
  - .agents
  - .agents/commands
  - .agents/skills
  - .agents/scripts
  - .agents/scripts/apkg.ts
```

## Manual Verification Steps

After installation, verify everything is set up correctly:

1. **Check directory structure:**
   ```bash
   ls -la .agents/
   ```
   You should see three directories: `commands`, `skills`, and `scripts`

2. **Verify subdirectories exist:**
   ```bash
   ls -la .agents/commands .agents/skills .agents/scripts
   ```
   All three directories should be present

3. **Confirm apkg.ts was downloaded:**
   ```bash
   ls -lh .agents/scripts/apkg.ts
   ```
   The file should exist and have a reasonable size

4. **Check apkg.ts file type:**
   ```bash
   file .agents/scripts/apkg.ts
   ```
   Should show it's a text/script file

5. **Test apkg.ts (requires Deno):**
   ```bash
   deno run --allow-read .agents/scripts/apkg.ts --help
   ```
   Should display apkg help information (if implemented)

## Troubleshooting

### curl not installed

**Error:**
```
sh: curl: command not found
```

**Solution:**
Install curl using your package manager:
- **Debian/Ubuntu:** `sudo apt-get install curl`
- **RedHat/CentOS:** `sudo yum install curl`
- **macOS:** `brew install curl` (or use built-in curl)

### Network connectivity issues

**Error:**
```
[ERROR] Failed to download: https://raw.githubusercontent.com/mgreenly/apkg/HEAD/agents/scripts/apkg.ts
[ERROR] Please check your internet connection and try again.
```

**Solution:**
1. Check your internet connection
2. Verify you can access GitHub: `ping github.com`
3. Try accessing the URL directly in a browser
4. Check if you're behind a proxy that might be blocking GitHub
5. If the repository is private, you'll need to download and run the script manually

### Permission issues

**Error:**
```
mkdir: cannot create directory '.agents': Permission denied
```

**Solution:**
1. Make sure you have write permissions in the current directory
2. Try running from your home directory or a directory you own
3. Do NOT run the script with `sudo` - install in a user-owned directory

### File already exists

**Behavior:**
The script will skip any existing files or directories and report them as "Skipped"

**Solution:**
This is normal and safe behavior. If you want to re-download files:
1. Remove the existing file: `rm .agents/scripts/apkg.ts`
2. Run the bootstrap script again

### Script fails validation

**Error:**
```
sh: syntax error near unexpected token
```

**Solution:**
1. Make sure you're using a POSIX-compliant shell (sh, bash, zsh should all work)
2. Try downloading the script and running it directly:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/mgreenly/apkg/HEAD/install.sh -o install.sh
   chmod +x install.sh
   ./install.sh
   ```

## What Gets Installed

After running the bootstrap script, your directory structure will look like:

```
.
└── .agents/
    ├── commands/     (empty, ready for your custom commands)
    ├── skills/       (empty, ready for your agent skills)
    └── scripts/
        └── apkg.ts   (core apkg package manager)
```

## Next Steps

After installation:

1. **Verify the installation** using the steps above
2. **Configure your project** with apkg (see main documentation)
3. **Start using agent-based development** workflows

## Uninstall

To remove apkg:

```bash
rm -rf .agents
```

This removes the entire `.agents/` directory and all its contents.

## Security Considerations

The bootstrap script:
- Only creates directories in the current working directory
- Downloads files from the official apkg repository on GitHub
- Does not require or use elevated (sudo) privileges
- Does not modify system files or install system-wide packages
- Can be reviewed before running by visiting: https://raw.githubusercontent.com/mgreenly/apkg/HEAD/install.sh

## Manual Installation

If you prefer not to use the curl pipe method, you can install manually:

```bash
# Create directory structure
mkdir -p .agents/commands .agents/skills .agents/scripts

# Download apkg.ts
curl -fsSL https://raw.githubusercontent.com/mgreenly/apkg/HEAD/agents/scripts/apkg.ts \
  -o .agents/scripts/apkg.ts

# Verify
ls -la .agents/scripts/apkg.ts
```

## Getting Help

- **Documentation:** See the main README.md
- **Issues:** Report problems at https://github.com/mgreenly/apkg/issues
- **Source code:** View the install.sh script at https://github.com/mgreenly/apkg/blob/main/install.sh
