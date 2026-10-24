# 记忆与存储

第一版复用 LivingMemory，不自建向量库或社交记忆算法。

| 数据 | 宿主机持久化位置 |
| --- | --- |
| AstrBot 对话历史、模型与人格配置 | data/ |
| LivingMemory 插件数据 | data/ 下的插件数据目录（具体结构取决于版本） |
| NapCat 配置 | napcat/config/ |
| QQ 登录态 | ntqq/ |
| 备份归档 | backups/ |

文件夹已加入 .gitignore，绝不上传公开仓库。运行 ./scripts/backup.sh 时会短暂停止服务以减少不一致风险，完成后恢复此前正在运行的容器。

聊天历史和长期记忆不同：聊天历史不是无限记忆，LivingMemory 需要提取、索引和按上下文检索。若更换 Embedding 模型，按插件指南重建索引。

建议初期使用 session 作用域，仅对自己的会话开放记忆；如果他人加入聊天，应检查隔离策略。禁止自动把私聊信息分享到群聊。QQ 中删除聊天消息并不保证插件数据、模型请求记录或备份同时删除，需要分别处理。

本地存储不等于云端模型没有收到上下文；请谨慎提供隐私内容。

官方文档：https://lxfight-s-astrbot-plugins.github.io/astrbot_plugin_livingmemory/guide/getting-started
