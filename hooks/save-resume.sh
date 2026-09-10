#!/usr/bin/env bash
# SessionEnd hook: record this session's ID in .claude-resume in the project
# directory so the claude() shell wrapper (claude-resume.sh) can offer to
# resume it on the next launch. Skipped for /clear and logout, where resuming
# the ended session makes no sense.
set -euo pipefail

input="$(cat)"
session_id="$(jq -r '.session_id // empty' <<<"$input")"
cwd="$(jq -r '.cwd // empty' <<<"$input")"
reason="$(jq -r '.reason // empty' <<<"$input")"

[ -n "$session_id" ] && [ -n "$cwd" ] && [ -d "$cwd" ] || exit 0
case "$reason" in
    clear|logout) exit 0 ;;
esac

printf '%s\n' "$session_id" > "$cwd/.claude-resume"
