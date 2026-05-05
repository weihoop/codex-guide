#!/usr/bin/env python3
"""Validate the bundled Codex execpolicy rules with representative commands."""
from __future__ import annotations

import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
RULES = ROOT / "config-templates" / "rules" / "default.rules"

CASES: list[tuple[list[str], str]] = [
    (["git", "status"], "allow"),
    (["rg", "TODO", "."], "allow"),
    (["npm", "run", "test"], "allow"),
    (["rm", "file.txt"], "prompt"),
    (["git", "push", "origin", "main"], "prompt"),
    (["npm", "install"], "prompt"),
    (["docker", "ps"], "prompt"),
    (["rm", "-rf", "/"], "forbidden"),
    (["dd", "if=/dev/zero", "of=/dev/disk0"], "forbidden"),
]


def decision_for(command: list[str]) -> str:
    result = subprocess.run(
        ["codex", "execpolicy", "check", "--rules", str(RULES), "--pretty", *command],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode != 0:
        print(result.stdout, end="")
        print(result.stderr, end="", file=sys.stderr)
        raise SystemExit(result.returncode)
    data = json.loads(result.stdout)
    return data.get("decision", "")


def main() -> int:
    failures: list[str] = []
    for command, expected in CASES:
        actual = decision_for(command)
        rendered = " ".join(command)
        print(f"{rendered}: {actual}")
        if actual != expected:
            failures.append(f"{rendered}: expected {expected}, got {actual}")

    if failures:
        print("\nExecpolicy check failed:")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("Execpolicy check passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
