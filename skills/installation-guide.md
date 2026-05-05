# Skills 安装指南

## 用户级安装

```bash
mkdir -p ~/.codex/skills
cp -R my-skill ~/.codex/skills/
```

## 项目内共享

团队可以把 Skill 源码放在仓库中，但是否自动加载取决于当前 Codex 版本和配置。稳妥做法是在 README 中说明安装步骤。

## 验证

启动 Codex 后，用一个明确触发语句测试：

```text
请使用 code-reviewer 的方式审查当前改动。
```
