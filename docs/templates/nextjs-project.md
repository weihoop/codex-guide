# Next.js 项目 AGENTS 模板

```markdown
# AGENTS.md

本文件是 Next.js 项目的长期 Codex 指令。一次性需求放在 prompt 里。

## 项目概览

- 项目类型：Next.js 应用
- 语言：TypeScript
- UI/样式：`<Tailwind/CSS Modules/设计系统>`
- 包管理器：`<npm/pnpm/yarn/bun>`

## 常用命令

| 场景 | 命令 |
| --- | --- |
| 安装依赖 | `npm install` |
| 本地开发 | `npm run dev` |
| Lint | `npm run lint` |
| 测试 | `npm test` |
| 构建 | `npm run build` |

## 工作原则

- 保持现有设计系统和组件结构。
- 修改组件后检查移动端和桌面端表现。
- 优先复用现有组件、hooks、数据获取方式。
- 不引入未讨论的新 UI 库或状态管理库。

## 安全边界

- 不把服务端密钥暴露到 `NEXT_PUBLIC_*`。
- 不提交 `.env.local`、构建产物或本地缓存。
- 修改认证、支付、权限、路由中间件前先说明风险。

## 完成标准

- 至少运行 lint、相关测试或 build。
- 说明视觉/交互检查点和未覆盖风险。
```
