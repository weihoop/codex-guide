# Codex 快速开始

## 三步上手

1. [安装与登录](installation.md)。
2. 创建项目级 `AGENTS.md`。
3. 配置保守的 `~/.codex/config.toml`。

## 第一个任务

```bash
codex --sandbox read-only
```

输入：

```text
请只读分析当前项目，说明技术栈、入口文件、测试命令和风险点。
```

## 第二个任务

复制模板：

```bash
cp config-templates/AGENTS.template.md AGENTS.md
```

改写项目名称、命令和规则后，再启动：

```bash
codex --sandbox workspace-write --ask-for-approval on-request
```
