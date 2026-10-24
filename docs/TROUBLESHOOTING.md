# 常见问题

**手机 QQ 发了消息但道友不回复？**

按顺序检查：电脑是否开机且未休眠 → Docker 容器状态 → NapCat 是否保持 QQ 登录 → OneBot 与 AstrBot 是否连通 → 模型 API 是否可用 → AstrBot 白名单和人格配置。

**容器 Up 就代表在线吗？**

不是。容器运行不代表 QQ 登录有效，也不代表模型 API 调用成功。

**停电重启后不在线？**

确认 Docker systemd 服务已启用，且没有手工停止容器；检查电脑 BIOS 是否支持断电恢复通电开机。

**安装记忆插件后不记得？**

先确认 Embedding Provider ID 已设置，运行 /lmem status 检查插件状态。对话记录和可检索的长期记忆是两回事。

**怎样远程管理？**

手机 QQ 聊天不需要远程管理通道。如果需要管理 WebUI，用 SSH 隧道或带认证的私网连接，绝不要公开暴露 6099/6185。

**使用宿主机 CLIProxyAPI（8317）无法获取模型列表？**

- AstrBot 在 Docker 内，`localhost` 与 `127.0.0.1` 都表示容器本身。DaoYou Compose 已配置 `host.docker.internal:host-gateway`，可以通过 `http://host.docker.internal:8317/v1` 访问 Ubuntu 宿主机监听在可达接口上的 API。
- 修改后 `git pull --ff-only && docker compose up -d --no-deps --force-recreate astrbot`；不会重建 NapCat，也不会清除 QQ 登录数据。
- AstrBot 的提供商「代理地址」应留空，除非确实配置了容器可访问的代理；`http://127.0.0.1:7890` 在容器里通常不是宿主机代理。
- 若宿主机请求 `/v1/models` 返回 401，说明请求未携带 API Key（这并非接口离线）。AstrBot 要填写 CLIProxyAPI `api-keys` 下的调用密钥，而非管理面板密钥；客户端使用 `Authorization: Bearer <API Key>`。
- 如果 8317 监听 `*:8317`，留意它可能对局域网开放，配置宿主机防火墙限制访问，或将其限制在本机与 Docker 网络所需的接口。不要直接开放至公网。
- 如保存提供商后获取模型列表仍失败，可在 AstrBot 中添加自定义模型 ID 并使用「测试模型」验证，优先区分认证、API 兼容性与模型列表问题。

参考：https://docs.docker.com/compose/how-tos/networking/ 与 https://docs.astrbot.app/en/providers/llm.html

**会被 QQ 封号吗？**

NapCat 非官方接入存在风控风险。推荐独立测试 QQ 小号，不要使用长期依赖的主账号。
