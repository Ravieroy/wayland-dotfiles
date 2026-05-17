#!/usr/bin/env python3

import json
from pathlib import Path


SUMMARY_FILE = Path.home() / "thesis-progress" / "thesis_progress_summary.json"


def main():
    if not SUMMARY_FILE.exists():
        print(json.dumps({
            "text": "Thesis --%",
            "tooltip": "Thesis progress summary file not found",
            "class": "error"
        }))
        return

    try:
        data = json.loads(SUMMARY_FILE.read_text(encoding="utf-8"))
        percent = float(data.get("overall_progress", 0))
    except Exception:
        print(json.dumps({
            "text": "Thesis ?%",
            "tooltip": "Could not read thesis progress summary",
            "class": "error"
        }))
        return

    print(json.dumps({
        "text": f"󱛉 {percent:.0f}%",
        "tooltip": f"Overall thesis progress: {percent:.2f}%",
        "class": "normal"
    }))


if __name__ == "__main__":
    main()
