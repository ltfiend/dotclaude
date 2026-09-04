#!/usr/bin/env bash
# Deploy this repo's Claude Code configuration into ~/.claude via symlinks.
#
# Safe to re-run: existing correct symlinks are left alone, and any existing
# regular file/dir at a target path is backed up to <name>.bak.<timestamp>
# before being replaced.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
STAMP="$(date +%Y%m%d%H%M%S)"

echo "Repo:   $REPO_DIR"
echo "Target: $CLAUDE_DIR"

# Make sure submodules (skills, statusline) are present.
if [ -d "$REPO_DIR/.git" ] || [ -f "$REPO_DIR/.git" ]; then
    git -C "$REPO_DIR" submodule update --init --recursive
fi

mkdir -p "$CLAUDE_DIR/skills"

link() {
    local src="$1" dst="$2"

    if [ ! -e "$src" ]; then
        echo "SKIP    $dst (missing source $src)"
        return
    fi

    if [ -L "$dst" ]; then
        if [ "$(readlink "$dst")" = "$src" ]; then
            echo "OK      $dst"
            return
        fi
        rm "$dst"
    elif [ -e "$dst" ]; then
        mv "$dst" "$dst.bak.$STAMP"
        echo "BACKUP  $dst -> $dst.bak.$STAMP"
    fi

    ln -s "$src" "$dst"
    echo "LINK    $dst -> $src"
}

link "$REPO_DIR/settings.json"        "$CLAUDE_DIR/settings.json"
link "$REPO_DIR/hooks"                "$CLAUDE_DIR/hooks"
link "$REPO_DIR/skills/dns-expert"    "$CLAUDE_DIR/skills/dns-expert"
link "$REPO_DIR/skills/bind-admin"    "$CLAUDE_DIR/skills/bind-admin"
link "$REPO_DIR/statusline/statusline.sh"  "$CLAUDE_DIR/statusline.sh"
link "$REPO_DIR/statusline/statusline.png" "$CLAUDE_DIR/statusline.png"

echo "Done."
