# treecreate

`treecreate` creates a clean `.txt` file with a project directory tree.

## Install

### Linux

```bash
chmod +x install.sh
./install.sh
```

If `~/.local/bin` is not in your shell path, add it for your shell.

For bash or zsh, add this to `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

For fish, run:

```fish
fish_add_path $HOME/.local/bin
```

### Windows

Run this in PowerShell from the project folder:

```powershell
.\install.ps1
```

If PowerShell blocks scripts, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\install.ps1
```

After installing, restart PowerShell if `treecreate` is not found.

## Update

If you installed with `./install.sh`, the command in `~/.local/bin/treecreate`
points to this project file. That means changes in `treecreate` are available
right away.

After editing the script, you can check it with:

```bash
python3 -m py_compile treecreate
treecreate --all -o /tmp/treecreate-test.txt
```

If you moved this project folder or want to reinstall the command, run:

```bash
./install.sh
```

Check which command your shell uses:

```bash
which treecreate
```

Remove the installed command:

```bash
rm ~/.local/bin/treecreate
```

On Windows, remove:

```powershell
Remove-Item "$env:USERPROFILE\.local\bin\treecreate.cmd"
```

## GitHub Release

This project includes a GitHub Actions workflow that creates ready archives for
Linux and Windows when you push a version tag.

Create and push a release tag:

```bash
git add .
git commit -m "Prepare release build"
git tag v1.0.0
git push origin main
git push origin v1.0.0
```

GitHub will create a release with:

```text
treecreate-v1.0.0-linux.tar.gz
treecreate-v1.0.0-windows.zip
```

Linux users download the `.tar.gz`, unpack it, then run:

```bash
./install.sh
```

Windows users download the `.zip`, unpack it, then run in PowerShell:

```powershell
.\install.ps1
```

## Usage

Create `project-tree.txt` for the current folder:

```bash
treecreate
```

When run without options in a terminal, `treecreate` asks which mode to use:

```text
1) normal - skip hidden files and folders
2) all    - include hidden files and folders
```

Run the menu explicitly:

```bash
treecreate --interactive
```

Run all mode directly:

```bash
treecreate --all
```

Create a tree for another project:

```bash
treecreate /path/to/project -o tree.txt
```

Limit depth:

```bash
treecreate -d 3
```

Exclude extra files:

```bash
treecreate -x "*.png" -x "tmp"
```

Use ASCII output:

```bash
treecreate --ascii
```

By default, common heavy or noisy folders are skipped, including `.git`, `node_modules`,
`venv`, `dist`, `build`, caches, and log files.
