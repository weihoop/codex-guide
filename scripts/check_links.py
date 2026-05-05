#!/usr/bin/env python3
"""Simple local Markdown link checker for this documentation repo."""
from __future__ import annotations

import pathlib
import re
import sys
from urllib.parse import urlparse, unquote

ROOT = pathlib.Path(__file__).resolve().parents[1]
LINK_RE = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")

errors: list[str] = []

for md in sorted(ROOT.rglob("*.md")):
    text = md.read_text(encoding="utf-8")
    for raw in LINK_RE.findall(text):
        target = raw.split()[0].strip("<>")
        if not target or target.startswith("#"):
            continue
        parsed = urlparse(target)
        if parsed.scheme in {"http", "https", "mailto"}:
            continue
        if parsed.scheme:
            continue
        path_part = unquote(target.split("#", 1)[0])
        if not path_part:
            continue
        dest = (md.parent / path_part).resolve()
        try:
            dest.relative_to(ROOT)
        except ValueError:
            errors.append(f"{md.relative_to(ROOT)}: link escapes repo: {target}")
            continue
        if not dest.exists():
            errors.append(f"{md.relative_to(ROOT)}: missing link: {target}")

if errors:
    print("Markdown link check failed:")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print("Markdown link check passed")
