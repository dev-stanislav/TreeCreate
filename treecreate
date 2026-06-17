#!/usr/bin/env python3
"""Create a clean text tree for a project directory."""

from __future__ import annotations

import argparse
import fnmatch
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


DEFAULT_EXCLUDES = {
    ".git",
    ".hg",
    ".svn",
    ".idea",
    ".vscode",
    "__pycache__",
    ".pytest_cache",
    ".mypy_cache",
    ".ruff_cache",
    ".cache",
    ".DS_Store",
    "node_modules",
    "vendor",
    "dist",
    "build",
    "target",
    ".next",
    ".nuxt",
    ".venv",
    "venv",
    "env",
    ".env",
    "*.pyc",
    "*.pyo",
    "*.log",
}


@dataclass
class Stats:
    dirs: int = 0
    files: int = 0
    skipped: int = 0


@dataclass(frozen=True)
class Glyphs:
    branch: str
    last: str
    pipe: str
    space: str


UNICODE_GLYPHS = Glyphs(branch="├── ", last="└── ", pipe="│   ", space="    ")
ASCII_GLYPHS = Glyphs(branch="|-- ", last="`-- ", pipe="|   ", space="    ")


def choose_include_hidden() -> bool:
    print("Choose tree mode:")
    print("  1) normal - skip hidden files and folders")
    print("  2) all    - include hidden files and folders")

    while True:
        answer = input("Select [1/2] (default: 1): ").strip().lower()
        if answer in {"", "1", "normal", "n"}:
            return False
        if answer in {"2", "all", "a"}:
            return True
        print("Please enter 1 or 2.")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="treecreate",
        description="Create a beautiful .txt tree of a project directory.",
    )
    parser.add_argument(
        "path",
        nargs="?",
        default=".",
        help="Project directory to scan. Default: current directory.",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="project-tree.txt",
        help="Output .txt file. Default: project-tree.txt.",
    )
    parser.add_argument(
        "-d",
        "--max-depth",
        type=int,
        default=None,
        help="Maximum depth to print. Example: -d 3.",
    )
    parser.add_argument(
        "-a",
        "--all",
        action="store_true",
        help="Include hidden files and folders.",
    )
    parser.add_argument(
        "-x",
        "--exclude",
        action="append",
        default=[],
        help="Exclude pattern. Can be used many times. Example: -x '*.png' -x 'tmp'.",
    )
    parser.add_argument(
        "--no-default-excludes",
        action="store_true",
        help="Do not use the default ignore list.",
    )
    parser.add_argument(
        "--ascii",
        action="store_true",
        help="Use ASCII tree symbols instead of Unicode box drawing.",
    )
    parser.add_argument(
        "-i",
        "--interactive",
        action="store_true",
        help="Ask which tree mode to use.",
    )
    parser.add_argument(
        "--no-summary",
        action="store_true",
        help="Do not add the directory/file summary at the end.",
    )
    return parser.parse_args()


def should_skip(
    path: Path,
    root: Path,
    patterns: Iterable[str],
    include_hidden: bool,
    output_path: Path,
) -> bool:
    name = path.name

    if path.resolve() == output_path.resolve():
        return True

    if not include_hidden and name.startswith("."):
        return True

    rel = path.relative_to(root).as_posix()
    return any(fnmatch.fnmatch(name, pattern) or fnmatch.fnmatch(rel, pattern) for pattern in patterns)


def list_children(
    directory: Path,
    root: Path,
    patterns: Iterable[str],
    include_hidden: bool,
    output_path: Path,
    stats: Stats,
) -> list[Path]:
    children: list[Path] = []

    try:
        iterator = directory.iterdir()
    except PermissionError:
        stats.skipped += 1
        return children

    for child in iterator:
        if should_skip(child, root, patterns, include_hidden, output_path):
            stats.skipped += 1
            continue
        children.append(child)

    return sorted(children, key=lambda item: (item.is_file(), item.name.lower()))


def build_tree(
    directory: Path,
    root: Path,
    patterns: Iterable[str],
    include_hidden: bool,
    output_path: Path,
    max_depth: int | None,
    glyphs: Glyphs,
    stats: Stats,
    prefix: str = "",
    depth: int = 0,
) -> list[str]:
    if max_depth is not None and depth >= max_depth:
        return []

    children = list_children(directory, root, patterns, include_hidden, output_path, stats)
    lines: list[str] = []

    for index, child in enumerate(children):
        is_last = index == len(children) - 1
        connector = glyphs.last if is_last else glyphs.branch
        suffix = "/" if child.is_dir() else ""
        lines.append(f"{prefix}{connector}{child.name}{suffix}")

        if child.is_dir():
            stats.dirs += 1
            extension = glyphs.space if is_last else glyphs.pipe
            lines.extend(
                build_tree(
                    child,
                    root,
                    patterns,
                    include_hidden,
                    output_path,
                    max_depth,
                    glyphs,
                    stats,
                    prefix + extension,
                    depth + 1,
                )
            )
        else:
            stats.files += 1

    return lines


def main() -> int:
    args = parse_args()
    include_hidden = args.all

    if args.interactive or (len(sys.argv) == 1 and sys.stdin.isatty()):
        include_hidden = choose_include_hidden()

    root = Path(args.path).expanduser().resolve()

    if not root.exists():
        print(f"treecreate: path does not exist: {root}")
        return 1

    if not root.is_dir():
        print(f"treecreate: path is not a directory: {root}")
        return 1

    output_path = Path(args.output).expanduser()
    if not output_path.is_absolute():
        output_path = Path.cwd() / output_path
    output_path.parent.mkdir(parents=True, exist_ok=True)

    patterns = set(args.exclude)
    if not args.no_default_excludes:
        patterns.update(DEFAULT_EXCLUDES)

    stats = Stats()
    glyphs = ASCII_GLYPHS if args.ascii else UNICODE_GLYPHS
    title = f"{root.name}/"
    lines = [title]
    lines.extend(
        build_tree(
            directory=root,
            root=root,
            patterns=patterns,
            include_hidden=include_hidden,
            output_path=output_path,
            max_depth=args.max_depth,
            glyphs=glyphs,
            stats=stats,
        )
    )

    if not args.no_summary:
        lines.extend(
            [
                "",
                f"{stats.dirs} directories, {stats.files} files",
            ]
        )
        if stats.skipped:
            lines.append(f"{stats.skipped} skipped by filters")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Created {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
