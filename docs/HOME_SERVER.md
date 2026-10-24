# 家用电脑常驻运行

## 目标

家里的电脑长期开机、联网，运行 NapCat 与 AstrBot；道友以一个专用 QQ 账号作为联系人存在于手机 QQ 中。你人在外地、手机用移动网络也能直接发消息。**不需要家庭公网 IP、路由器端口映射或者手机和家用电脑处于同一 Wi-Fi。**

本项目默认是 Ubuntu / Linux + Docker Compose。Windows 电脑也可以使用 Docker Desktop，但开机自动恢复的行为受 Docker Desktop 启动方式和 Windows 登录会话影响，不能直接等同于 Linux systemd 守护进程。

## Linux 开机自动恢复

~~~bash
# 开启系统启动时运行 Docker（Linux + systemd）
sudo systemctl enable --now docker

# 第一次安装/修改配置后运行一次
./scripts/start.sh

# 查看是否已启动
./scripts/status.sh
~~~

compose.yaml 中两个服务都设置了 restart: unless-stopped：Docker daemon 恢复后，会尝试重启**之前正常运行、未被用户手动停止**的容器。若此前运行 ./scripts/stop.sh 手动停止，可能需要再运行 ./scripts/start.sh 才恢复。

**无需设置 cron 每分钟拉起道友，也不必把 API Key 写进开机脚本。**

## 电脑、电源与网络

- 关闭系统自动休眠 / 待机；不要仅锁定桌面就认为容器会停。屏幕熄灭一般不影响运行，但电脑进入休眠会中断。
- 笔记本还应检查合盖行为和电源策略；台式机要检查断电恢复后的 BIOS 自动开机选项（机器支持时）。
- 网络中断后容器可能仍显示 Up，但 QQ 连接可能掉线；需要在 NapCat 日志查看实际账号状态。
- 默认后台端口 6099、6185 只监听 127.0.0.1；不要把管理端口映射到公网。
- 如果只是使用手机 QQ 发送聊天消息，不需要从手机访问 WebUI。

## 重启测试

1. 初次扫码登录 QQ 小号，完成 AstrBot 模型与消息平台配置、测试白名单。
2. 手机 QQ（自己的主号）给道友小号发送「你好」，确认有回复。
3. 运行 ./scripts/backup.sh 保存初始备份。
4. 重启家用电脑，确保 Docker daemon 启动、系统未休眠。
5. 再次从手机 QQ 发消息；如果不回复，依次检查 Docker、NapCat QQ 登录态、OneBot 连接、AstrBot、模型 API。

## 维护

~~~bash
./scripts/status.sh
docker compose logs -f --tail=100
./scripts/backup.sh

# 升级前备份；镜像 latest 可能变更配置或需要迁移
docker compose pull
docker compose up -d
~~~

升级前备份，避免直接批量清空数据卷。长期稳定运行后可将镜像固定到经过验证的版本标签；不要在生产使用中盲目自动更新。

## Windows 家用电脑

第一版文档提供的是 Ubuntu/Linux 方案。若家里是 Windows 10/11，建议先确认 Docker Desktop + WSL2 能否在用户登录后自动启动；**不要承诺 Windows 尚未登录桌面时 QQ 一定在线**。后续可给出专门的 Windows 部署方法，或将常驻进程放到独立 Linux 主机/小型服务器上。
