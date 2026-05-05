# Codex 配置包

## 配置包内容

```text
codex-config/
├── install.sh
├── config.simple.toml
├── config.full.toml
├── AGENTS.template.md
├── requirements.example.toml
├── rules/
│   └── default.rules
├── VERSION
└── CHANGELOG.md
```

| 文件 | 说明 |
| --- | --- |
| `install.sh` | 交互式安装脚本，自动备份后覆盖配置 |
| `config.simple.toml` | 推荐默认配置，`workspace-write` + `on-request` |
| `config.full.toml` | 进阶配置，含 profiles、MCP、provider 占位示例 |
| `rules/default.rules` | Codex execpolicy 权限规则 |
| `AGENTS.template.md` | 项目级指令模板 |
| `requirements.example.toml` | 团队约束示例，不是 Codex 原生配置 |

## 快速安装

```bash
wget https://github.com/weihoop/codex-guide/releases/latest/download/codex-config.tar.gz
tar -xzf codex-config.tar.gz
cd codex-config
bash install.sh
```

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

验证：

```bash
python3 scripts/check_execpolicy.py
```

## 手动安装

```bash
mkdir -p ~/.codex/rules
cp config.simple.toml ~/.codex/config.toml
cp rules/default.rules ~/.codex/rules/default.rules
cp AGENTS.template.md ~/.codex/AGENTS.template.md
chmod 600 ~/.codex/config.toml ~/.codex/rules/default.rules ~/.codex/AGENTS.template.md
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
git tag v$(cat VERSION)
git push origin main
git push origin v$(cat VERSION)
gh release create v$(cat VERSION) \
  dist/codex-config.tar.gz \
  dist/codex-config-v$(cat VERSION).tar.gz \
  --title "Codex Guide v$(cat VERSION)" \
  --notes-file CHANGELOG.md
```
