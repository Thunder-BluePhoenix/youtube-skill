#!/usr/bin/env bash
set -euo pipefail

main() {
    echo "Uninstalling claude-youtube..."

    # Remove skill directories (Claude Code, Codex CLI / Gemini CLI)
    rm -rf "${HOME}/.claude/skills/youtube" "${HOME}/.agents/skills/youtube"

    echo "claude-youtube uninstalled."
    echo "Restart Claude Code to complete removal."
}

main "$@"
