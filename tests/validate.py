#!/usr/bin/env python3
"""Static checks only. These do not substitute for real Docker/QQ testing."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
required = (
    "README.md", "compose.yaml", ".gitignore", ".env.example",
    "docs/QUICKSTART.md", "docs/HOME_SERVER.md", "docs/MEMORY.md",
    "docs/ROADMAP.md", "persona/daoyou.md",
    "scripts/start.sh", "scripts/backup.sh", "scripts/doctor.sh",
)
for item in required:
    file = ROOT / item
    assert file.is_file() and file.stat().st_size > 0, item
try:
    import yaml
except ImportError:
    print("SKIP: PyYAML missing")
else:
    config = yaml.safe_load((ROOT / "compose.yaml").read_text())
    assert set(config["services"]) == {"napcat", "astrbot"}
    for name, port in (("napcat", 6099), ("astrbot", 6185)):
        service = config["services"][name]
        assert service["restart"] == "unless-stopped"
        assert service["ports"] == [f"127.0.0.1:{port}:{port}"]
print("OK: static checks passed")
