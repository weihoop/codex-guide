# Codex 配置包

## 配置包内容

```text
codex-config/
├── install.sh
├── config.simple.toml
├── config.full.toml
├── AGENTS.global.md
├── AGENTS.template.md
├── requirements.example.toml
├── rules/
│   ├── default.rules
│   └── relaxed.rules
├── VERSION
└── CHANGELOG.md
```

| 文件 | 说明 |
| --- | --- |
| `install.sh` | 交互式安装脚本，自动备份；默认保留 config，只更新 rules |
| `config.simple.toml` | 推荐默认配置，`workspace-write` + `on-request` |
| `config.full.toml` | 进阶配置，含 profiles、MCP、provider 占位示例 |
| `rules/default.rules` | Codex execpolicy 保守默认规则 |
| `rules/relaxed.rules` | 可选宽松规则，放行安装、联网、推送、容器和远程命令 |
| `AGENTS.global.md` | 全局指令参考模板，可初始化为 `~/.codex/AGENTS.md` |
| `AGENTS.template.md` | 项目级指令模板，复制到仓库根目录后按项目改写 |
| `requirements.example.toml` | 团队约束示例，不是 Codex 原生配置 |

## 快速安装

安装最新 Release：

```bash
wget https://github.com/weihoop/codex-guide/releases/latest/download/codex-config.tar.gz
tar -xzf codex-config.tar.gz
cd codex-config
bash install.sh
```

安装指定版本：

```bash
wget https://github.com/weihoop/codex-guide/releases/download/v0.1.3/codex-config-v0.1.3.tar.gz
tar -xzf codex-config-v0.1.3.tar.gz
cd codex-config
bash install.sh
```

## Release 包功能

### 安装

- 交互式安装到 `~/.codex/`，支持 `CODEX_HOME` 自定义安装目录。
- 默认使用 `rules-only` 模式，保留现有 `config.toml`，只更新权限规则和 AGENTS 模板。
- 如果 `~/.codex/AGENTS.md` 不存在，安装脚本会用 `AGENTS.global.md` 初始化全局指令；如果已存在则保留不覆盖。
- 可选 `simple` / `full` 模式覆盖安装 `config.toml`。
- 安装过程会显示覆盖警告，并记录日志到 `~/.codex/install.log`。

### 新功能

- 提供精简版和完整版 `config.toml` 模板。
- 提供保守和宽松两套 execpolicy 权限规则。
- 提供全局 `AGENTS.global.md` 和项目级 `AGENTS.template.md` 模板。
- 提供团队约束示例 `requirements.example.toml`。

### 安全保护

- 自动备份已有 `config.toml`、`rules/`、`AGENTS.md`、`AGENTS.global.md` 和 `AGENTS.template.md`。
- 不备份、不覆盖登录凭据、历史记录、会话、sqlite 日志和 skills。
- 默认规则允许常见本地只读/测试命令，对删除、推送、安装、联网和部署类命令保留确认。

### 内容

- `config.simple.toml`：精简配置。
- `config.full.toml`：完整配置，含 profiles、MCP、provider 占位示例。
- `rules/default.rules`：保守默认权限规则。
- `rules/relaxed.rules`：宽松权限规则。
- `AGENTS.global.md`：全局指令模板。
- `AGENTS.template.md`：项目指令模板。
- `install.sh`：自动安装脚本。
- `PROJECT-README.md`、`CHANGELOG.md`、`VERSION`：文档和版本信息。

支持平台：macOS、Linux。

脚本会备份：

- `~/.codex/config.toml`
- `~/.codex/rules/`
- `~/.codex/AGENTS.md`
- `~/.codex/AGENTS.template.md`

脚本不会备份或覆盖：

- `~/.codex/auth.json`
- `history.jsonl`
- sessions
- sqlite 日志
- skills

## 权限策略

`rules/default.rules` 的目标是减少日常低风险命令的确认，同时保留危险操作保护：

| decision | 示例 |
| --- | --- |
| `allow` | `rg`、`sed`、`git status`、`git diff`、`npm run test` |
| `prompt` | `rm`、`git push`、`npm install`、`curl`、`docker`、`kubectl` |
| `forbidden` | `dd`、`mkfs`、`rm -rf /`、`terraform destroy` |

`prompt` 表示执行前询问；如果你想自动放行安装、联网、推送、容器和远程命令，可以改用 `rules/relaxed.rules`。宽松规则会把 `terraform destroy`、`kubectl delete`、`docker system prune` 和关机/重启类命令降为询问，但仍阻止 `dd`、`mkfs`、`rm -rf /` 等不可逆机器级破坏操作。

验证：

```bash
python3 scripts/check_execpolicy.py
```

该脚本会同时检查保守默认规则和宽松规则的代表性命令。

## 手动安装

保留现有 `config.toml`，只安装规则和模板：

```bash
mkdir -p ~/.codex/rules
cp rules/default.rules ~/.codex/rules/default.rules
cp AGENTS.global.md ~/.codex/AGENTS.global.md
cp AGENTS.template.md ~/.codex/AGENTS.template.md
test -f ~/.codex/AGENTS.md || cp AGENTS.global.md ~/.codex/AGENTS.md
chmod 600 ~/.codex/rules/default.rules ~/.codex/AGENTS.global.md ~/.codex/AGENTS.template.md ~/.codex/AGENTS.md
```

如果要使用宽松规则：

```bash
cp rules/relaxed.rules ~/.codex/rules/default.rules
chmod 600 ~/.codex/rules/default.rules
```

如果是新用户，也可以手动安装 simple 配置：

```bash
cp config.simple.toml ~/.codex/config.toml
chmod 600 ~/.codex/config.toml
```

## 恢复

安装脚本会创建：

```text
~/.codex/backup-YYYYMMDD-HHMMSS/
```

恢复示例：

```bash
cp -R ~/.codex/backup-YYYYMMDD-HHMMSS/config.toml ~/.codex/
cp -R ~/.codex/backup-YYYYMMDD-HHMMSS/rules ~/.codex/
```

## 构建 Release 包

在仓库根目录运行：

```bash
bash scripts/build-release.sh
```

生成：

- `dist/codex-config.tar.gz`
- `dist/codex-config-v<version>.tar.gz`

## 发布到 GitHub Release

```bash
bash scripts/build-release-notes.sh > dist/release-notes.md
git tag v$(cat VERSION)
git push origin main
git push origin v$(cat VERSION)
gh release create v$(cat VERSION) \
  dist/codex-config.tar.gz \
  dist/codex-config-v$(cat VERSION).tar.gz \
  --title "Codex Guide v$(cat VERSION)" \
  --notes-file dist/release-notes.md
```
