# Codex 快速参考卡

## 核心文件

| 文件 | 作用 |
| --- | --- |
| `AGENTS.md` | 项目级 agent 指令 |
| `~/.codex/config.toml` | 用户级 Codex 配置 |
| `~/.codex/skills/` | 用户安装的 Skills |
| `.gitignore` | 排除本地状态和密钥 |

## 常用命令

```bash
codex                         # 启动交互会话
codex "解释这个项目"          # 启动时附带 prompt
codex exec "生成变更摘要"      # 非交互执行
codex review                  # 非交互代码审查
codex apply                   # 应用最近 agent diff
codex resume --last           # 继续最近会话
codex fork --last             # 分叉最近会话
codex login                   # 登录
codex logout                  # 登出
codex update                  # 更新 CLI
```

## 权限速查

```bash
codex --sandbox read-only
codex --sandbox workspace-write
codex --ask-for-approval on-request
codex --ask-for-approval never
```

推荐组合：

| 场景 | 命令 |
| --- | --- |
| 只读审查 | `codex --sandbox read-only` |
| 日常开发 | `codex --sandbox workspace-write --ask-for-approval on-request` |
| 相对安全的自动模式 | `codex --sandbox workspace-write --ask-for-approval never` |
| CI | `codex exec --ask-for-approval never` |

## 自动模式

日常项目中优先使用受沙箱保护的自动模式：

```bash
codex --sandbox workspace-write --ask-for-approval never
```

非交互任务可写成：

```bash
codex exec --sandbox workspace-write --ask-for-approval never "帮我更新 README"
```

也可以保存为 profile：

```toml
[profiles.auto]
sandbox_mode = "workspace-write"
approval_policy = "never"
```

启动时指定：

```bash
codex --profile auto
```

只有在 Docker、临时 VM 等外部隔离环境中，才考虑：

```bash
codex --dangerously-bypass-approvals-and-sandbox
```

## 配置覆盖

```bash
codex -c model='"gpt-5.4"'
codex -c shell_environment_policy.inherit=all
codex -p dev
```

`-c` 的值按 TOML 解析；字符串通常需要额外引号。

## Execpolicy

```bash
codex execpolicy check --rules config-templates/rules/default.rules --pretty git status
codex execpolicy check --rules config-templates/rules/default.rules --pretty rm file.txt
python3 scripts/check_execpolicy.py
```

| 决策 | 含义 | 示例 |
| --- | --- | --- |
| `allow` | 不再反复确认 | `git status`、`rg`、`npm run test` |
| `prompt` | 执行前询问，不是自动放行 | `rm`、`git push`、`npm install` |
| `forbidden` | 直接阻止 | `dd`、`rm -rf /` |

要自动放行安装、联网、推送、容器和远程命令，可选择宽松规则：

```bash
cp config-templates/rules/relaxed.rules ~/.codex/rules/default.rules
chmod 600 ~/.codex/rules/default.rules
```

宽松规则仍会询问 `terraform destroy`、`kubectl delete`、`docker system prune` 和关机/重启类命令，并阻止 `dd`、`mkfs`、`rm -rf /` 等不可逆机器级破坏操作。

## MCP

```bash
codex mcp list
codex mcp add docs -- npx -y @modelcontextprotocol/server-filesystem ./docs
codex mcp get docs
codex mcp remove docs
```

## Plugins

```bash
codex plugin --help
codex plugin marketplace --help
```

## 最小 `AGENTS.md`

```markdown
# AGENTS.md

## Project

一句话说明项目。

## Commands

- Test: `npm test`
- Lint: `npm run lint`
- Build: `npm run build`

## Rules

- 不要提交密钥或本地状态文件。
- 修改代码后运行相关测试。
- 不要覆盖用户未提交的改动。
```
