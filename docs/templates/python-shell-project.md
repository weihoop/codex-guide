# Python/Shell 项目 AGENTS 模板

```markdown
# AGENTS.md

本文件是 Python/Shell 自动化项目的长期 Codex 指令。一次性任务目标放在 prompt 里。

## 项目概览

- 项目类型：Python / Shell 自动化
- 运行环境：`<本地/服务器/CI>`
- 包管理器：`<pip/uv/poetry/none>`
- 测试框架：`<pytest/none>`

## 常用命令

| 场景 | 命令 |
| --- | --- |
| 安装依赖 | `<command>` |
| 测试 | `pytest` |
| 格式检查 | `ruff format --check .` |
| Lint | `ruff check .` |
| Python 语法检查 | `python3 -m py_compile <file.py>` |

## 工作原则

- Shell 脚本默认用 `bash script.sh` 执行，不强制添加 `+x`。
- Python 脚本默认用 `python3 script.py` 执行。
- 生产命令先做只读检查、dry-run 或 `--help` 参数验证。
- 日志输出要便于排障，但不能输出密钥。

## 安全边界

- 不在脚本、日志或示例配置中写真实 token、AK/SK、密码。
- 删除、覆盖、重启服务、修改云资源前必须说明影响和回滚方式。
- CLI 超时后先查询状态，不直接重复创建资源。

## 完成标准

- 运行语法检查、相关测试或 `--help`。
- 说明验证结果、运行前提和生产风险。
```
