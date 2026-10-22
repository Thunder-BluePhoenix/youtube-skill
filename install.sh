#!/usr/bin/env bash
set -euo pipefail

# Claude YouTube Installer
# Set CLAUDE_YOUTUBE_SRC to a local checkout to install from it instead of GitHub (used by CI).

main() {
    # Claude Code reads ~/.claude/skills; Codex CLI and Gemini CLI read ~/.agents/skills
    SKILL_DIRS=("${HOME}/.claude/skills/youtube" "${HOME}/.agents/skills/youtube")
    ARCHIVE_URL="https://github.com/Thunder-BluePhoenix/youtube-skill/archive/refs/heads/main.tar.gz"
    RAW_URL="https://raw.githubusercontent.com/Thunder-BluePhoenix/youtube-skill/main"

    echo "=== Installing claude-youtube ==="
    echo ""

    if [ -n "${CLAUDE_YOUTUBE_SRC:-}" ]; then
        SRC="${CLAUDE_YOUTUBE_SRC}"
    else
        # Check prerequisites
        for cmd in curl tar; do
            command -v "${cmd}" >/dev/null 2>&1 || { echo "Error: ${cmd} is required but not installed." >&2; exit 1; }
        done

        TEMP_DIR=$(mktemp -d)
        trap 'rm -rf "${TEMP_DIR}"' EXIT

        echo "Downloading claude-youtube..."
        if ! curl -fsSL "${ARCHIVE_URL}" | tar -xz -C "${TEMP_DIR}"; then
            echo "Error: failed to download ${ARCHIVE_URL}" >&2
            exit 1
        fi
        SRC="${TEMP_DIR}/youtube-skill-main"
    fi

    if [ ! -f "${SRC}/skills/claude-youtube/SKILL.md" ]; then
        echo "Error: skill files not found in ${SRC}" >&2
        exit 1
    fi

    # Replace any previous install so files removed upstream don't linger
    echo "Installing skill files..."
    for dir in "${SKILL_DIRS[@]}"; do
        rm -rf "${dir}"
        mkdir -p "${dir}"
        cp -R "${SRC}/skills/claude-youtube/." "${dir}/"
        echo "  Installed: ${dir}"
    done

    echo ""
    echo "claude-youtube installed for Claude Code, Codex CLI, and Gemini CLI."
    echo ""
    echo "Usage:"
    echo "  Claude Code:          /youtube audit"
    echo "  Codex / Gemini CLI:   ask \"youtube audit @yourchannel\""
    echo ""
    echo "To uninstall: curl -fsSL ${RAW_URL}/uninstall.sh | bash"
}

main "$@"
