#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skill"
DEFAULT_CODEX_DEST="$HOME/.codex/skills/solana-anchor"
DEFAULT_CLAUDE_DEST="$HOME/.claude/skills/solana-anchor"

TARGET="codex"
DEST=""
YES=false

print_help() {
  cat <<'USAGE'
Solana Anchor Skill installer

Usage:
  ./install.sh [options]

Options:
  --target codex      Install to ~/.codex/skills/solana-anchor (default)
  --target claude     Install to ~/.claude/skills/solana-anchor
  --dest PATH         Install to a custom skill directory
  -y, --yes           Skip confirmation prompt
  -h, --help          Show help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      if [[ $# -lt 2 || "${2:-}" == --* ]]; then
        echo "--target requires a value: codex or claude" >&2
        exit 1
      fi
      TARGET="${2:-}"
      shift 2
      ;;
    --dest)
      if [[ $# -lt 2 || "${2:-}" == --* ]]; then
        echo "--dest requires a path" >&2
        exit 1
      fi
      DEST="${2:-}"
      shift 2
      ;;
    -y|--yes)
      YES=true
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      print_help
      exit 1
      ;;
  esac
done

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Cannot find skill payload at $SOURCE_DIR" >&2
  exit 1
fi

if [[ -z "$DEST" ]]; then
  case "$TARGET" in
    codex)
      DEST="$DEFAULT_CODEX_DEST"
      ;;
    claude)
      DEST="$DEFAULT_CLAUDE_DEST"
      ;;
    *)
      echo "Unsupported target: $TARGET" >&2
      echo "Use --target codex or --target claude." >&2
      exit 1
      ;;
  esac
fi

echo "Solana Anchor Skill installer"
echo ""
echo "Source: $SOURCE_DIR"
echo "Destination: $DEST"
echo ""

if [[ "$YES" != true ]]; then
  read -r -p "Install skill to this destination? [Y/n] " reply
  if [[ "$reply" =~ ^[Nn]$ ]]; then
    echo "Installation cancelled."
    exit 0
  fi
fi

if [[ -d "$DEST" ]]; then
  backup="$DEST.backup.$(date +%Y%m%d%H%M%S)"
  echo "Existing installation found. Moving it to $backup"
  mv "$DEST" "$backup"
fi

mkdir -p "$(dirname "$DEST")"
mkdir -p "$DEST"
cp -R "$SOURCE_DIR"/. "$DEST"/

echo ""
echo "Installed solana-anchor skill to:"
echo "  $DEST"
echo ""
echo "Try:"
echo '  Generate tests for this Anchor program. Detect the existing Anchor test setup first.'
