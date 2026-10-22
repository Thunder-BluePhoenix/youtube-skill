"""
Build upload bundles of the skill for chat apps that can't install from disk.

Outputs (in dist/):
  youtube-skill.zip      Agent Skills folder (SKILL.md at youtube/SKILL.md) for
                         ChatGPT Skills upload or any Agent Skills tool
  chat/instructions.md   Paste into a Custom GPT's or Gemini Gem's instructions
  chat/*.md              4 knowledge files to upload (fits the Gem 10-file cap)

Usage:
    python scripts/build_bundles.py
    python scripts/build_bundles.py --out build
"""

import argparse
import shutil
import subprocess
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILL = ROOT / "skills" / "claude-youtube"

# Custom GPT instructions are capped at 8,000 characters, so the full SKILL.md
# goes in as knowledge and this short prompt points at it.
INSTRUCTIONS = """\
You are a YouTube growth strategist for creators. Your full operating manual is
the knowledge file youtube-skill.md: read it before answering and follow its
routing, quality rules, and output formats exactly.

Commands: the user may type "/youtube <command>" or just describe the task.
Commands are audit, seo, script, hook, thumbnail, strategy, calendar, shorts,
analyze, repurpose, monetize, competitor, metadata, ideate. For each command,
follow its section in sub-skills.md. Pull benchmarks and rules from
references.md, and channel-type guidance from templates.md.

You cannot run the Python scripts the manual mentions. Where it says to run one,
ask the user to paste the data instead (channel stats, video list, analytics
export, transcript), or use web search if available. Where it says to run
parallel agents, cover each dimension yourself in sequence.

Ask for the channel URL/handle, niche, and goal if they are missing. Give
specific, copy-paste-ready output, not generic advice.
"""


def concat(folder: Path, title: str) -> str:
    """Join every .md in a folder into one file, one section per source file."""
    parts = [f"# {title}\n"]
    for f in sorted(folder.glob("*.md")):
        parts.append(f"\n\n<!-- {f.name} -->\n# {f.stem}\n\n{f.read_text(encoding='utf-8')}")
    return "".join(parts)


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[1])
    parser.add_argument("--out", default="dist", help="output directory (default: dist)")
    out = ROOT / parser.parse_args().out

    chat = out / "chat"
    shutil.rmtree(chat, ignore_errors=True)  # only what we create, never --out itself
    chat.mkdir(parents=True)

    with zipfile.ZipFile(out / "youtube-skill.zip", "w", zipfile.ZIP_DEFLATED) as z:
        # git-tracked files only, so local tool state (.claude-flow/, *.db, caches) never ships
        tracked = subprocess.run(
            ["git", "ls-files", "-z", "."], cwd=SKILL, capture_output=True, text=True, check=True
        ).stdout.split("\0")
        for rel in sorted(filter(None, tracked)):
            z.write(SKILL / rel, Path("youtube") / rel)

    (chat / "instructions.md").write_text(INSTRUCTIONS, encoding="utf-8")
    shutil.copy(SKILL / "SKILL.md", chat / "youtube-skill.md")
    for name in ("sub-skills", "references", "templates"):
        (chat / f"{name}.md").write_text(concat(SKILL / name, name), encoding="utf-8")

    assert len(INSTRUCTIONS) <= 8000, "Custom GPT instructions limit is 8,000 chars"
    for f in [out / "youtube-skill.zip", *sorted(chat.iterdir())]:
        print(f"{f}  ({f.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
