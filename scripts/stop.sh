#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose stop
echo '道友已停止，聊天数据和 QQ 登录状态仍留在本机。'
