#!/usr/bin/env bash
set -euo pipefail

# Claude YouTube Installer
# Set CLAUDE_YOUTUBE_SRC to a local checkout to install from it instead of GitHub (used by CI).

main() {
    SKILL_DIR="${HOME}/.claude/skills/youtube"
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
    rm -rf "${SKILL_DIR}"
    mkdir -p "${SKILL_DIR}"
    cp -R "${SRC}/skills/claude-youtube/." "${SKILL_DIR}/"

    echo ""
    echo "claude-youtube installed to ${SKILL_DIR}"
    echo ""
    echo "Usage:"
    echo "  1. Start Claude Code:  claude"
    echo "  2. Run commands:       /youtube audit"
    echo ""
    echo "To uninstall: curl -fsSL ${RAW_URL}/uninstall.sh | bash"
}

main "$@"
