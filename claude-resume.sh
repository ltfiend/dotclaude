# Source this from ~/.bashrc:  source ~/.claude/claude-resume.sh
#
# Wraps the claude CLI: the save-resume.sh SessionEnd hook records the last
# session ID in ./.claude-resume, and this wrapper offers to resume it on the
# next plain `claude` launch. Any arguments (claude -p, claude --resume, ...)
# bypass the prompt.
claude() {
    local resume_file=".claude-resume" id reply
    if [ $# -eq 0 ] && [ -t 0 ] && [ -r "$resume_file" ]; then
        id="$(head -n1 "$resume_file" | tr -d '[:space:]')"
        if [ -n "$id" ]; then
            read -r -p "Resume previous Claude session (${id:0:8})? [y/N] " reply
            case "$reply" in
                [yY]*)
                    command claude --resume "$id"
                    return
                    ;;
            esac
        fi
    fi
    command claude "$@"
}
