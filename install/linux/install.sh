#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
BIN_DIR="${HOME}/.local/bin"
SOURCE_FILE="${PROJECT_DIR}/src/treecreate.py"

mkdir -p "$BIN_DIR"
ln -sf "$SOURCE_FILE" "$BIN_DIR/treecreate"
chmod +x "$SOURCE_FILE"

echo "Installed treecreate to ${BIN_DIR}/treecreate"
echo "If the command is not found, add this to your shell config:"
echo ""
echo "bash/zsh:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "fish:"
echo "  fish_add_path \$HOME/.local/bin"
