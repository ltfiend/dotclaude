#!/usr/bin/env bash
# PreToolUse hook (Bash matcher): force a confirmation prompt when a git
# add/commit would include a PROMPTS.md prompt log in the repository.
# Outputs a permissionDecision "ask" in that case; stays silent otherwise.

input=$(cat)
cmd=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)
[ -z "$cmd" ] && exit 0

# Only git add / git commit invocations are of interest
grep -Eq '\bgit\b[^|;&]*\b(add|commit)\b' <<<"$cmd" || exit 0

ask() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}

# 1) Command explicitly names a PROMPTS.md file
if grep -q 'PROMPTS\.md' <<<"$cmd"; then
  ask "This git command names PROMPTS.md (a prompt log). Confirm it should be part of the repository."
fi

# Honor an explicit -C <dir> so status checks look at the right repo
gitdir=$(grep -oE '\-C[= ]+[^ ]+' <<<"$cmd" | head -1 | sed -E 's/-C[= ]+//')

# 2) Broad staging (add -A/./--all/*, commit -a/-am) that could sweep one in
if grep -Eq '\bgit\b[^|;&]*\badd\b[^|;&]*(-A\b|--all\b| \.( |$)|\*)' <<<"$cmd" \
   || grep -Eq '\bgit\b[^|;&]*\bcommit\b[^|;&]*(-a\b|--all\b|-am\b)' <<<"$cmd"; then
  if git ${gitdir:+-C "$gitdir"} status --porcelain 2>/dev/null | grep -Eq '(^|[ /])PROMPTS\.md$'; then
    ask "This broad git add/commit would sweep in a PROMPTS.md prompt log present in the repo. Confirm it should be part of the repository."
  fi
fi

# 3) Plain commit with a PROMPTS.md already staged
if grep -Eq '\bgit\b[^|;&]*\bcommit\b' <<<"$cmd"; then
  if git ${gitdir:+-C "$gitdir"} diff --cached --name-only 2>/dev/null | grep -Eq '(^|/)PROMPTS\.md$'; then
    ask "A PROMPTS.md prompt log is currently staged and would be committed. Confirm it should be part of the repository."
  fi
fi

exit 0
