#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose ps
echo '提示：容器 Up 不代表 QQ 登录有效。若手机收不到回复，请检查 NapCat、AstrBot 和模型 API。'
