# dotclaude

Portable [Claude Code](https://claude.ai/code) configuration — the pieces worth
carrying to a new system, with none of the login credentials or per-project
state that lives in `~/.claude` alongside them.

The externally maintained pieces are pinned as git submodules so they track
their own GitHub repos:

| Path | Repo | Installs as |
|---|---|---|
| `statusline/` | [ltfiend/claude-statusline](https://github.com/ltfiend/claude-statusline) | `~/.claude/statusline.sh` |
| `skills/dns-expert/` | [ltfiend/claude-dns-skill](https://github.com/ltfiend/claude-dns-skill) | `~/.claude/skills/dns-expert` |
| `skills/bind-admin/` | [ltfiend/claude-bind-skill](https://github.com/ltfiend/claude-bind-skill) | `~/.claude/skills/bind-admin` |

## Contents

| File / dir | What it is |
|---|---|
| `settings.json` | User settings: permissions, model, hooks, statusline, enabled plugins |
| `hooks/` | `log-prompts.sh` (prompt journal), `check-prompts-in-git.sh` (blocks committing `PROMPTS.md`), `check-ssh-agent.sh` (ssh-agent sanity check) |
| `install.sh` | Symlinks everything above into `~/.claude` |

## Install

```sh
git clone --recurse-submodules https://github.com/ltfiend/dotclaude.git
cd dotclaude
./install.sh
```

`install.sh` creates symlinks from `~/.claude` into the clone, so pulling the
repo (and `git submodule update --remote`) updates the live config. Anything
already present at a target path is backed up to `<name>.bak.<timestamp>`
first, and re-running the script is a no-op for links that are already
correct. Set `CLAUDE_CONFIG_DIR` to install somewhere other than `~/.claude`.

Hook scripts need `jq` on the PATH.

## Deliberately excluded

Everything Claude Code generates per machine or per login: credentials
(`.credentials.json`), conversation/project history, sessions, caches, stats,
plans, plugin install state (plugin *enablement* is carried by
`enabledPlugins` in `settings.json`), and `settings.local.json`. A
[gitleaks](https://github.com/gitleaks/gitleaks) GitHub Action scans every
push as a backstop against secrets landing here.
