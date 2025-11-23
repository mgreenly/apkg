# apkg - Agent Package Manager

A lightweight package manager for agent-based development workflows. Manage reusable agent skills, commands, and scripts across your projects.

## Installation

Install apkg with this one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/mgreenly/apkg/HEAD/install.sh | sh
```

This creates the `.agents/` directory structure and downloads the core apkg tool.

For detailed installation instructions, troubleshooting, and manual installation options, see [BOOTSTRAP.md](BOOTSTRAP.md).

## What is apkg?

apkg is a package manager designed for agent-based development. It manages:

- **Commands** - Custom slash commands for CLI interaction
- **Skills** - Reusable agent behaviors and workflows
- **Scripts** - Automation tools (TypeScript/Deno)

All packages are stored in the `.agents/` directory and managed through a simple `manifest.json` file.

## Quick Start

After installation, your project will have this structure:

```
.
└── .agents/
    ├── commands/     (custom slash commands)
    ├── skills/       (agent skills and workflows)
    └── scripts/
        └── apkg.ts   (package manager)
```

## Usage

apkg provides three main commands:

### List Packages

Display all packages defined in your manifest:

```bash
deno run --allow-read .agents/scripts/apkg.ts list
```

Shows package name, type, source repository, and installation status.

### Install Packages

Install packages from the manifest:

```bash
deno run --allow-read --allow-write .agents/scripts/apkg.ts install
```

Downloads and installs all packages defined in `manifest.json`.

### Update Packages

Update installed packages to their latest versions:

```bash
deno run --allow-read --allow-write .agents/scripts/apkg.ts update
```

Fetches the latest version of each package from its source repository.

## Package Manifest

Packages are defined in `manifest.json` at your project root:

```json
{
  "packages": [
    {
      "name": "example-skill",
      "type": "skill",
      "source": "https://github.com/username/repo",
      "path": "skills/example.md"
    }
  ]
}
```

Each package specifies:
- **name** - Unique identifier for the package
- **type** - Package type: `command`, `skill`, or `script`
- **source** - GitHub repository URL
- **path** - Path to the file within the source repository

apkg downloads packages from GitHub raw URLs and places them in the appropriate `.agents/` subdirectory.

## Documentation

- [BOOTSTRAP.md](BOOTSTRAP.md) - Detailed installation guide and troubleshooting

## Requirements

- **Deno** - JavaScript/TypeScript runtime (https://deno.land)
- **curl** - For downloading the installer

## Repository Structure

```
apkg/
├── install.sh           # Bootstrap installer
├── BOOTSTRAP.md         # Installation documentation
├── README.md            # This file
└── agents/
    └── scripts/
        └── apkg.ts      # Core package manager
```

## Security

The install script:
- Only creates directories in your current working directory
- Downloads files from the official apkg repository
- Requires no elevated privileges
- Can be reviewed at: https://github.com/mgreenly/apkg

## Getting Help

- **Issues**: https://github.com/mgreenly/apkg/issues
- **Source**: https://github.com/mgreenly/apkg

## License

See LICENSE file for details.
