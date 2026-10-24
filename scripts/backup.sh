#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p backups
chmod 700 backups
umask 077
mapfile -t running < <(docker compose ps --services --status running)
resume() {
  if (( ${#running[@]} > 0 )); then
    docker compose up -d "${running[@]}" >/dev/null || echo '自动重启失败，请检查容器状态。' >&2
  fi
}
trap resume EXIT
if (( ${#running[@]} > 0 )); then docker compose stop "${running[@]}"; fi
items=()
for dir in data napcat ntqq .env; do [[ ! -e "$dir" ]] || items+=("$dir"); done
if (( ${#items[@]} == 0 )); then echo '没有需要备份的数据'; exit 0; fi
archive="backups/daoyou-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$archive" "${items[@]}"
chmod 600 "$archive"
echo "备份成功: $archive"
echo '备份可能包含 QQ 登录态和 API Key，不要上传 GitHub 或公开分享。'
