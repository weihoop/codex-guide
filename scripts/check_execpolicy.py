#!/usr/bin/env python3
"""Validate the bundled Codex execpolicy rules with representative commands."""
from __future__ import annotations

import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
RULES_DIR = ROOT / "config-templates" / "rules"

RULE_CASES: dict[str, list[tuple[list[str], str]]] = {
    "default.rules": [
        (["git", "status"], "allow"),
        (["rg", "TODO", "."], "allow"),
        (["npm", "run", "test"], "allow"),
        (["rm", "file.txt"], "prompt"),
        (["git", "push", "origin", "main"], "prompt"),
        (["npm", "install"], "prompt"),
        (["docker", "ps"], "prompt"),
        (["rm", "-rf", "/"], "forbidden"),
        (["dd", "if=/dev/zero", "of=/dev/disk0"], "forbidden"),
    ],
    "relaxed.rules": [
        (["git", "push", "origin", "main"], "allow"),
        (["npm", "install"], "allow"),
        (["docker", "ps"], "allow"),
        (["kubectl", "get", "pods"], "allow"),
        (["terraform", "plan"], "allow"),
        (["ssh", "example.com"], "allow"),
        (["sudo", "echo", "ok"], "allow"),
        (["git", "reset", "--hard", "HEAD"], "allow"),
        (["git", "clean", "-fd"], "allow"),
        (["sudo", "rm", "-rf", "~"], "forbidden"),
        (["sudo", "rm", "-rf", "/tmp/example"], "prompt"),
        (["terraform", "destroy"], "prompt"),
        (["kubectl", "delete", "pod", "x"], "prompt"),
        (["sudo", "reboot"], "prompt"),
        (["sudo", "rm", "-rf", "/"], "forbidden"),
        (["sudo", "dd", "if=/dev/zero", "of=/dev/disk0"], "forbidden"),
        (["rm", "-rf", "/"], "forbidden"),
    ],
}


def decision_for(rules: pathlib.Path, command: list[str]) -> str:
    result = subprocess.run(
        ["codex", "execpolicy", "check", "--rules", str(rules), "--pretty", *command],
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
    for rules_name, cases in RULE_CASES.items():
        rules = RULES_DIR / rules_name
        print(f"[{rules_name}]")
        for command, expected in cases:
            actual = decision_for(rules, command)
            rendered = " ".join(command)
            print(f"{rendered}: {actual}")
            if actual != expected:
                failures.append(
                    f"{rules_name} {rendered}: expected {expected}, got {actual}"
                )
        print()

    if failures:
        print("\nExecpolicy check failed:")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("Execpolicy check passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
