# TreeCreate

Create a clean `.txt` tree of any project folder from the terminal.

```text
my-project/
├── src/
│   └── app.py
├── README.md
└── package.json

1 directories, 3 files
```

## Features

- Interactive mode for normal or full tree output
- Linux, macOS, and Windows support through Python
- Ready GitHub Release archives for Linux and Windows
- Default ignores for noisy folders like `.git`, `node_modules`, `venv`, `dist`, and caches
- Custom output file, max depth, exclude patterns, and ASCII output

## Project Layout

```text
TreeCreate/
├── .github/
│   └── workflows/
│       └── release.yml
├── install/
│   ├── linux/
│   │   └── install.sh
│   └── windows/
│       ├── install.ps1
│       └── treecreate.cmd
├── src/
│   └── treecreate.py
├── .gitignore
└── README.md
```

## Install

Download the latest release from GitHub, unpack it, then run the installer for
your system.

### Linux or macOS

```bash
chmod +x install/linux/install.sh
./install/linux/install.sh
```

If `treecreate` is not found after install, add `~/.local/bin` to your shell.

For bash or zsh:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

For fish:

```fish
fish_add_path $HOME/.local/bin
```

### Windows

Run PowerShell inside the unpacked folder:

```powershell
.\install\windows\install.ps1
```

If PowerShell blocks scripts:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\install\windows\install.ps1
```

Restart PowerShell if `treecreate` is not found right after installing.

## Usage

Create `project-tree.txt` for the current folder:

```bash
treecreate
```

When run without options in a terminal, TreeCreate asks what to include:

```text
Choose tree mode:
  1) normal - skip hidden files and folders
  2) all    - include hidden files and folders
```

Common commands:

| Command | What it does |
| --- | --- |
| `treecreate` | Open the interactive mode |
| `treecreate --all` | Include hidden files and folders |
| `treecreate --interactive` | Force the mode picker |
| `treecreate /path/to/project` | Create a tree for another folder |
| `treecreate -o tree.txt` | Save to `tree.txt` |
| `treecreate -d 3` | Limit output depth |
| `treecreate -x "*.png" -x "tmp"` | Exclude custom patterns |
| `treecreate --ascii` | Use ASCII tree symbols |

## Release

This repository includes a GitHub Actions workflow that builds release archives
when a version tag is pushed.

Create a new release:

```bash
git add .
git commit -m "Prepare release build"
git push origin main

git tag v1.0.0
git push origin v1.0.0
```

The release will include:

```text
treecreate-v1.0.0-linux.tar.gz
treecreate-v1.0.0-windows.zip
```

## Development

Check the script:

```bash
python3 -m py_compile src/treecreate.py
python3 src/treecreate.py --all -o /tmp/treecreate-test.txt
```

Reinstall the command after moving the project folder:

```bash
./install/linux/install.sh
```

Check which executable your shell uses:

```bash
which treecreate
```

Remove the installed Linux/macOS command:

```bash
rm ~/.local/bin/treecreate
```

Remove the installed Windows command:

```powershell
Remove-Item "$env:USERPROFILE\.local\bin\treecreate.cmd"
```
