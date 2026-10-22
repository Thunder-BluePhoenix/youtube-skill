#!/usr/bin/env bash
set -euo pipefail

# Claude YouTube Installer

main() {
    SKILL_DIR="${HOME}/.claude/skills/youtube"
    REPO_URL="https://github.com/Thunder-BluePhoenix/youtube-skill"
    RAW_URL="https://raw.githubusercontent.com/Thunder-BluePhoenix/youtube-skill/main"

    echo "=== Installing claude-youtube ==="
    echo ""

    # Check prerequisites
    command -v git >/dev/null 2>&1 || { echo "Error: git is required but not installed." >&2; exit 1; }

    # Clone to temp directory
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "${TEMP_DIR}"' EXIT

    echo "Downloading claude-youtube..."
    if ! git clone --quiet --depth 1 "${REPO_URL}" "${TEMP_DIR}/claude-youtube"; then
        echo "Error: failed to download ${REPO_URL}" >&2
        exit 1
    fi

    # Replace any previous install so files removed upstream don't linger
    echo "Installing skill files..."
    rm -rf "${SKILL_DIR}"
    mkdir -p "${SKILL_DIR}"
    cp -R "${TEMP_DIR}/claude-youtube/skills/claude-youtube/." "${SKILL_DIR}/"

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
