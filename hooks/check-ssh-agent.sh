#!/bin/bash
# Claude Code hook: warn if ssh-agent has no keys loaded
# Event: UserPromptSubmit
#
# Note: the fallback socket path assumes a systemd-managed user ssh-agent
# (ssh-agent.socket unit + $XDG_RUNTIME_DIR). On non-systemd systems set
# $SSH_AUTH_SOCK in your shell init instead.

export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$XDG_RUNTIME_DIR/ssh-agent.socket}"

if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
    echo '{"decision":"warn","reason":"⚠️  ssh-agent socket not found. Run: systemctl --user start ssh-agent.socket"}'
    exit 0
fi

if ! ssh-add -l &>/dev/null; then
    echo '{"decision":"warn","reason":"⚠️  No SSH keys loaded. Run: ssh-add"}'
    exit 0
fi

# Keys are loaded, all good
echo '{}'
