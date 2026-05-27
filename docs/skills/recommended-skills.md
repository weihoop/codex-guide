# Codex 推荐 Skills 与工作流

> 口径说明：这里的“推荐”不是“必装”。第三方 Skills 需要先审查来源、权限、脚本和依赖，再按项目场景选择安装。不要把未经验证的 Skills 直接放进生产仓库或全局环境。

Codex 真正好用，不靠一次装满工具，而靠三件事：

1. 项目有清晰的 `AGENTS.md`。
2. 常用工作流被 Skills、脚本或命令固化。
3. 高风险操作有 sandbox、approval、测试和回滚闭环。

## 先按场景选择

| 场景 | 优先考虑 | 不建议 |
| --- | --- | --- |
| 日常编码 | TDD、代码审查、验证闭环类 Skills | 一次装很多泛用 Skills |
| 前端/React/Next.js | Vercel Agent Skills、设计检查、视觉验证 | 只靠口头描述样式 |
| 长项目/多阶段任务 | Planning with Files、上下文管理、任务日志 | 只在对话里保存计划 |
| 外部服务自动化 | MCP + Skills、最小权限凭据 | 把真实 token 写进 Skill 或 prompt |
| 学习写 Skills | 官方/高质量参考实现、优秀作者案例 | 直接复制未知来源脚本 |

## 十类值得评估的能力栈

| 能力栈 | 价值 | 风险 | 落地建议 |
| --- | --- | --- | --- |
| Superpowers / TDD / Review / Verification | 强制先测、再改、再审查，减少 agent 偷懒 | 可能增加 token 和流程成本 | 先只启用 TDD、code review、verification 三类流程 |
| Slash commands / 工作流命令 | 把常见任务变成可复用入口 | 命令过多会增加记忆负担 | 只保留高频命令，例如 plan、review、release、deploy |
| MiniMax / 全栈流程卡 | 用流程卡覆盖前端、移动端、文档等任务 | 来源和适配性需要核验 | 作为团队流程模板参考，不直接全量安装 |
| 官方参考 Skills | 学习 `SKILL.md` 结构、触发条件和边界写法 | 可能绑定特定产品生态 | 用来学习写法，移植前先改成 Codex 项目语境 |
| Vercel Agent Skills | React / Next.js 性能、Web 质量审查 | 规则可能不适合所有项目 | 前端项目优先评估，和项目设计系统一起使用 |
| Planning with Files | 把计划、决策和进度写到文件，长任务不易跑偏 | 计划文件可能泄露项目细节 | 建议放 `docs/plans/`，敏感项目注意 `.gitignore` |
| Context Engineering Skills | 教 agent 管理上下文、压缩信息、避免漂移 | 规则太重会干扰小任务 | 写入长任务指南和项目 `AGENTS.md` 的轻量版本 |
| Composio / 外部服务 Skills | 让 agent 调 GitHub、Slack、Gmail、云服务等 | 凭据、权限、审计风险高 | 只用最小权限 token，优先走 MCP，保留人工审批 |
| Antfu 等高手案例 | 学习高质量 Skills 的组织方式 | 不一定适合当前栈 | 拆开学习触发词、约束和示例，不盲目照搬 |
| Awesome Agent Skills 索引 | 先搜索已有能力，避免重复造轮子 | 索引不等于安全白名单 | 作为发现入口，安装前必须做安全审查 |

## 安装前安全检查

第三方 Skill 安装前至少检查：

- 来源是否可信，仓库是否活跃，许可证是否允许使用。
- `SKILL.md` 是否清楚说明触发时机、输入、输出和限制。
- 是否包含脚本；脚本是否会删除文件、上传数据、联网或改系统配置。
- 是否读取 `~/.codex/`、`~/.ssh/`、`.env`、云凭据、浏览器配置或项目私有数据。
- 是否要求 API key；如果需要，是否支持环境变量和最小权限。
- 是否会调用外部服务；是否有审计日志和退出方式。
- 是否和项目 `AGENTS.md`、团队安全规则冲突。
- 是否能用一个低风险 demo 任务验证效果。

## 推荐落地路径

### 个人机器

1. 保留一个强约束的 `~/.codex/AGENTS.md`。
2. 只安装 2-3 个最常用 Skills：TDD/review、planning、前端审查。
3. 每装一个 Skill，跑一个小任务验证它是否真的提升质量。
4. 无法解释其脚本行为的 Skill，不装全局。

### 团队仓库

1. 先把项目规则写进 `AGENTS.md`。
2. 把团队固定流程写成 `docs/workflows/` 或 `scripts/`。
3. 对重复任务再提炼成 Skill。
4. 在 PR 中审查 Skill 变更，和代码一样要求 review。
5. 为高风险 Skills 配置 sandbox、approval 和最小权限凭据。

## 推荐目录结构

```text
repo/
├── AGENTS.md
├── docs/
│   ├── workflows/
│   │   ├── release.md
│   │   └── incident-response.md
│   └── plans/
│       └── YYYYMMDD-task.md
├── scripts/
│   └── verify.sh
└── skills/
    └── <team-skill>/
        └── SKILL.md
```

## 参考资源

- OpenAI Codex use cases：https://developers.openai.com/codex/explore/
- OpenAI Codex docs：https://developers.openai.com/codex/
- Vercel Agent Skills：https://github.com/vercel-labs/agent-skills
- Awesome Agent Skills：https://runaskill.com/
- Planning with Files 示例：https://skills.rest/skill/planning-with-files

## 结论

不要追求“装满”。优先把 `AGENTS.md`、测试闭环、计划文件和权限边界做好，再按任务场景选择 Skills。对团队来说，最有价值的 Skills 往往不是最多的，而是能稳定减少重复流程、降低返工和留下验证证据的那几个。
