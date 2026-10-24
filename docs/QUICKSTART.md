# 道友快速开始（Ubuntu）

前提：Docker Engine、Docker Compose v2、专用 QQ 测试小号、自己选择的模型 API。

## 1. 启动

~~~bash
git clone https://github.com/lbg2002/DaoYou.git
cd DaoYou
./scripts/start.sh
~~~

后台只开放给**本机**：
- AstrBot：http://127.0.0.1:6185
- NapCat：http://127.0.0.1:6099/webui

查看初次登录凭据及启动状态：
~~~bash
docker compose logs --tail=120 napcat astrbot
~~~

不要公开 WebUI token、登录二维码、初始管理员密码。登录后及时修改管理密码。

## 2. 登录道友 QQ 小号

使用 NapCat 扫码登录独立测试账号。根据 NapCat / AstrBot 日志验证 OneBot 连接成功。官方联合部署采用 MODE=astrbot：

https://docs.astrbot.app/deploy/astrbot/docker.html

## 3. 为 OneBot WebSocket 配置连接 Token（必做）

> WebUI Token 与 OneBot WebSocket Token 是不同凭据。不要使用相同密钥，也不要把凭据写入公开仓库。

在 Ubuntu 终端生成一次 256 位随机密钥（只在本机保存/复制，勿发给他人）：

~~~bash
openssl rand -hex 32
~~~

1. 进入 AstrBot WebUI → 机器人 → 创建机器人 → OneBot v11。
   - ID 可以填写 `daoyou`，启用。
   - 反向 WebSocket 地址：`0.0.0.0`。
   - 端口：`6199`。
   - **反向 WebSocket Token：粘贴刚生成的随机密钥**。
2. 进入 NapCat WebUI → 网络配置 → WebSocket 客户端。
   - 启用，URL：`ws://astrbot:6199/ws`（`astrbot` 是 Docker Compose 服务名）。
   - 消息格式：`Array`；心跳/重连间隔可使用 `5000` 毫秒。
   - **Token：粘贴完全相同的随机密钥**，无需 `Bearer` 前缀。
3. 保存后在 AstrBot「数据与日志 → 日志」检查是否显示适配器已连接。

OneBot 端口仅用于 Compose 内部网络；不要额外映射到宿主机或公网。建议为 WebUI 分别设置独立管理密码。若 `MODE=astrbot` 已自动创建连接配置，优先检查已有连接并修改对应 Token，避免重复建多个客户端连接。

上游参考：https://docs.astrbot.app/platform/aiocqhttp.html

## 4. 配置聊天模型

进入 AstrBot WebUI 的 LLM 配置添加 Provider：Base URL、API Key、Model ID 等均在后台设置；支持官方和兼容 API，不预置模型密钥。

**先测试没有长期记忆的普通 QQ 私聊可以回复。**

## 5. 必须配置白名单

初期只允许你的 QQ 主账号使用。到 AstrBot 的访问控制设置填写你的会话/用户 ID；注意白名单留空不代表禁止所有人，请实际用未授权账号测试。先不要将道友小号拉入陌生群聊。

## 6. 安装长期记忆

安装 LivingMemory 2.7.1（优先插件市场或项目官方说明）：https://github.com/lxfight-s-Astrbot-Plugins/astrbot_plugin_livingmemory

- 在 AstrBot LLM 配置中单独创建 Embedding Provider。
- 在插件设置中填写 embedding_provider_id 及 LLM Provider。
- 使用 Dashboard 检查记忆，建议从 session 作用域和仅自己可访问开始。
- 可通过 /lmem status、/lmem summarize、/lmem search 测试。

详见 https://lxfight-s-astrbot-plugins.github.io/astrbot_plugin_livingmemory/guide/getting-started

## 7. 设置人格

将 persona/daoyou.md 作为 AstrBot 人格提示词，默认自然中文聊天，不机械输出大段条目。

## 8. 验收

1. 自己的手机 QQ 主号给道友小号发送「你好」，确认有回复。
2. 新聊一个话题，跨天或重启后测试非敏感偏好能否被记住。
3. 未授权账号不应得到回复。
4. 运行 ./scripts/backup.sh，并验证重启后 QQ 仍正常登录。

长期常驻见 HOME_SERVER.md，排错见 TROUBLESHOOTING.md。
