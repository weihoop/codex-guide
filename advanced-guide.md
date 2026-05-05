# Codex 进阶使用手册

## 目录

- [配置 profiles](#配置-profiles)
- [MCP 集成](#mcp-集成)
- [Plugins](#plugins)
- [Skills](#skills)
- [非交互与自动化](#非交互与自动化)
- [会话管理](#会话管理)
- [调试工具](#调试工具)

## 配置 profiles

`~/.codex/config.toml` 可以为不同场景定义 profiles。推荐至少准备三个：

- `safe-review`：只读审查。
- `dev`：工作区写入，交互批准。
- `ci`：非交互、强隔离、永不询问。

示例见 [完整配置模板](config-templates/config.full.toml)。启动时指定：

```bash
codex -p safe-review
codex -p dev
codex exec -p ci "运行文档链接检查"
```

## MCP 集成

MCP 用来把外部上下文和工具接入 Codex，例如数据库、浏览器、内部知识库、设计系统或云平台。

常用命令：

```bash
codex mcp list
codex mcp add docs -- npx -y @modelcontextprotocol/server-filesystem ./docs
codex mcp get docs
codex mcp remove docs
```

最佳实践：

- 只给 MCP 暴露完成任务所需的最小目录或 API。
- 对生产系统使用只读 token。
- 在 `AGENTS.md` 中说明 MCP 的用途、限制和禁止行为。
- 团队共享 MCP 配置时使用模板，不提交真实凭据。

## Plugins

Plugins 更适合打包产品化能力，例如命令、技能、MCP、模板和说明文档的组合。它们通常比单个 Skill 更重，适合团队内分发。

```bash
codex plugin --help
codex plugin marketplace --help
```

使用建议：

- 单个可复用流程先做成 Skill。
- 需要多文件、多命令、多资源和版本管理时再做 Plugin。
- 插件说明中明确权限需求和安全边界。

## Skills

Skills 是轻量级工作流说明，适合把“怎么做一类任务”固化为 `SKILL.md`。典型场景：

- 代码审查方法。
- 发布流程。
- 文档转格式。
- 云资源巡检。
- 团队特定排障流程。

详见 [Skills 使用指南](skills.md)。

## 非交互与自动化

`codex exec` 适合 CI、脚本和批量任务：

```bash
codex exec "根据 git diff 生成变更摘要"
codex exec --sandbox read-only "审查当前分支安全风险"
codex exec --ask-for-approval never "同步 docs/INDEX.md"
```

自动化原则：

- 非交互任务的 prompt 必须明确输入、输出和禁止事项。
- CI 中使用 `never` 时，不要给生产密钥和未隔离文件系统。
- 对会修改文件的任务，要求 Codex 最后输出变更清单和验证命令。
- 高风险步骤拆成“先计划，人工确认，再执行”。

## 会话管理

```bash
codex resume
codex resume --last
codex fork
codex fork --last
```

推荐用法：

- `resume`：继续同一个任务上下文。
- `fork`：从历史上下文分叉，尝试另一种实现方案。
- 大任务分阶段后，及时让 Codex 总结当前状态，避免上下文过长。

## 调试工具

```bash
codex debug --help
codex debug models
codex debug prompt-input
```

调试时重点检查：

- 当前模型和 provider 是否符合预期。
- prompt input 是否包含敏感信息。
- `AGENTS.md` 是否被正确读取。
- sandbox 和 approval 是否与当前任务匹配。

## 进阶工作流示例

### 计划优先开发

```text
先不要写代码。请阅读需求和当前实现，输出决策完整的实现计划：涉及文件、接口变化、测试场景、风险和回滚方式。
```

### 分支收尾

```text
请检查当前分支是否可以合并：运行必要测试，审查 git diff，总结行为变化、风险和需要人工确认的点。
```

### 跨仓库文档同步

```bash
codex --cd ./codex-guide --add-dir ../claude-code-guide
```

只把 `../claude-code-guide` 作为只读参考时，在 prompt 中明确“不要修改参考仓库”。
