# 道友 · DaoYou

**把 AI 朋友养在家里的电脑上，用手机 QQ 随时和它聊天。**

DaoYou 是一个轻量部署整合工程，复用 [NapCat](https://github.com/NapNeko/NapCat-Docker)（QQ 消息收发）、[AstrBot](https://github.com/AstrBotDevs/AstrBot)（Agent、人格、模型配置）和 [LivingMemory](https://github.com/lxfight-s-Astrbot-Plugins/astrbot_plugin_livingmemory)（可选长期记忆）。

> 不是重写三个上游项目，也不是将云端模型部署在家里的显卡上。家用电脑运行 QQ 接入与机器人服务，模型可通过自定义 API 调用。

## 整体架构

```text
手机 QQ（你的主账号）
        │ QQ 互联网消息
        ▼
家用电脑（持续开机、联网）
   ├── NapCat：登录道友的 QQ 小号
   ├── AstrBot：聊天、人格、模型、插件
   └── LivingMemory：可选长期记忆（本地持久化）
                 │ HTTPS 模型 API
                 ▼
        自己选择的云端模型
```

**手机无须额外安装软件、访问家庭公网 IP 或连接同一个 Wi-Fi。** 电脑关机、休眠、断网或 QQ 掉线则暂时无法回复。

## Ubuntu 快速启动

```bash
git clone https://github.com/lbg2002/DaoYou.git
cd DaoYou
./scripts/start.sh
```

需先安装 Docker Engine 与 Docker Compose v2。首次运行后在本机访问：

- AstrBot：<http://127.0.0.1:6185>
- NapCat：<http://127.0.0.1:6099/webui>

扫码登录道友**专用 QQ 测试小号**，在 AstrBot 后台配置模型、人格与自己的白名单；长期记忆按文档单独配置。

查看 [完整部署步骤](docs/QUICKSTART.md) · [家用常驻运行](docs/HOME_SERVER.md) · [记忆说明](docs/MEMORY.md) · [路线图](docs/ROADMAP.md) · [人格模板](persona/daoyou.md)。

## 功能与状态

| 功能 | 实现 | 状态 |
| --- | --- | --- |
| QQ 私聊 | NapCat + AstrBot | 配置已编写，待真实账号验证 |
| 任意支持的模型 API | AstrBot Provider | 在 WebUI 自行配置 |
| 自然中文聊天 | 自定义人格模板 | 模板已提供 |
| 跨天记忆 | LivingMemory | 需要配置 LLM + Embedding |
| 家用电脑持续运行 | Docker Compose | 自动重启策略已配置，需操作系统保持开机 |
| 备份 | 本地脚本 | 已提供 |
| 主动社交 / 多人互动 | 可选 | 初版默认不开放 |

## 安全提醒

NapCat 是**非官方** QQ 接入方式，有账号风控风险。推荐专用小号，不要用常用主账号。后台端口仅监听本机，不暴露公网；第一版先只允许你自己的账号互动。数据库、令牌、QQ 登录态和备份不提交到公开仓库。调用云端模型时，对话上下文可能发送给模型供应商。

## 原则

**能复用的不重写；能配置的不开发；以实际聊天体验为核心。** 本仓库自有配置、脚本和文档按照 [MIT](LICENSE) 许可提供，上游组件各自遵循其许可证。
