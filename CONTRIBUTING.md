# Contributing

Thanks for helping improve Claude YouTube.

## Getting started

1. Fork the repo and create a branch from `main`.
2. Install your working copy locally to test it:
   ```bash
   CLAUDE_YOUTUBE_SRC="$PWD" bash install.sh
   ```
3. Run the skill in Claude Code (`/youtube <command>`) and check the output.

## Guidelines

- **SKILL.md** stays under 500 lines. Put detail in sub-skills or references.
- **Sub-skills** are single `.md` files in `sub-skills/`, not separate skill directories.
- **References** stay focused and at 200 lines or fewer (CI enforces this).
- **Python scripts** in `execution/` need a module docstring and an `argparse` CLI with `--help`. Keep them stdlib-only at import time; import optional packages (Google API client, yt-dlp) lazily and fail with an install hint.
- Keep instructions platform-neutral where you can: the same files run in Claude Code, Codex, Gemini CLI, ChatGPT, and Gemini. Claude-only features (parallel agents, MCP) need a fallback.
- Use kebab-case for file and directory names.
- Never commit API keys, OAuth tokens, or `client_secret*.json` files.

## Before opening a PR

CI runs these checks; you can run them locally:

```bash
python -m compileall -q skills/claude-youtube/execution
for f in skills/claude-youtube/execution/*.py; do python "$f" --help > /dev/null; done
shellcheck --severity=error install.sh uninstall.sh
python scripts/build_bundles.py   # ChatGPT / Gemini bundles
wc -l skills/claude-youtube/SKILL.md
```

In the PR description, say what changed and which commands you tested.

## Reporting bugs and ideas

Open an issue with the command you ran, what you expected, and what happened. For security issues, follow [SECURITY.md](SECURITY.md) instead of opening a public issue.

## License

By contributing, you agree that your contributions are licensed under the [GPL-3.0](LICENSE).
