#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v docker >/dev/null 2>&1 || ! docker compose version >/dev/null 2>&1; then
  echo '请先安装 Docker Engine 与 Docker Compose v2。' >&2
  exit 1
fi
if [[ ! -f .env ]]; then
  umask 077
  printf 'NAPCAT_UID=%s\nNAPCAT_GID=%s\nTZ=Asia/Shanghai\n' "$(id -u)" "$(id -g)" > .env
  echo '已生成私有 .env'
fi
mkdir -p data napcat/config ntqq backups
chmod 700 backups
docker compose --env-file .env config --quiet
docker compose --env-file .env up -d
echo '容器已启动（不代表 QQ 登录与模型连接已完成）'
echo 'AstrBot: http://127.0.0.1:6185'
echo 'NapCat: http://127.0.0.1:6099/webui'
echo '查看登录信息: docker compose logs --tail=100 napcat astrbot'
echo '完成 QQ 扫码、模型配置、访问控制后，才能通过手机 QQ 聊天。'
