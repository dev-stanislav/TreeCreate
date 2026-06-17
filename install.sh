#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"

mkdir -p "$BIN_DIR"
ln -sf "$SCRIPT_DIR/treecreate" "$BIN_DIR/treecreate"
chmod +x "$SCRIPT_DIR/treecreate"

echo "Installed treecreate to ${BIN_DIR}/treecreate"
echo "If the command is not found, add this to your shell config:"
echo ""
echo "bash/zsh:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "fish:"
echo "  fish_add_path \$HOME/.local/bin"
