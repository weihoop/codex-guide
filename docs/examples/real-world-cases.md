# Codex 实战案例

## 案例 1：新仓库初始化

目标：为空仓库创建文档结构。

步骤：

1. 让 Codex 读取参考仓库结构。
2. 输出信息架构计划。
3. 生成 README、索引、配置模板。
4. 运行链接和敏感词检查。

## 案例 2：代码审查

目标：审查 PR 的行为风险。

```bash
codex review
```

补充 prompt：

```text
请重点找会导致线上行为变化的问题，而不是格式建议。
```

## 案例 3：CI 生成 PR 摘要

```bash
codex exec --sandbox read-only --ask-for-approval never "根据 git diff 输出 PR 摘要和测试建议"
```
