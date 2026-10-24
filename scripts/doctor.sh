#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo '== DaoYou 环境检查 =='
for bin in git docker; do
  if command -v "$bin" >/dev/null 2>&1; then echo "[OK] $bin"; else echo "[缺失] $bin"; fi
done
if ! command -v docker >/dev/null 2>&1 || ! docker compose version >/dev/null 2>&1; then
  echo '[缺失] Docker Engine / Docker Compose v2'
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo '[警告] Docker daemon 未启动或当前用户没有访问权限'
  exit 1
fi
docker compose config --quiet
docker compose ps
echo 'Docker 容器重启策略为 unless-stopped；Linux 开机还需启动 Docker 服务。'
