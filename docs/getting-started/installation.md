# 安装与登录

## 安装

以官方 Quickstart 为准，常见方式：

```bash
npm install -g @openai/codex
codex --version
```

如果无法运行，检查：

- Node.js/npm 是否可用。
- 全局 npm bin 是否在 `PATH` 中。
- 公司网络是否需要代理。

## 登录

```bash
codex login
```

登出：

```bash
codex logout
```

## 更新

```bash
codex update
```

## 验证安装

```bash
codex --help
codex mcp --help
codex plugin --help
```

至少确认能看到 `exec`、`review`、`mcp`、`plugin`、`resume`、`fork` 等子命令。
