# 代码审查工作流

## CLI

```bash
codex review
```

## Prompt

```text
请以代码审查视角审查当前分支相对 main 的改动。 findings 优先，按严重程度排序，给出文件/行号。重点关注 bug、安全、回归和测试缺口。
```

## 输出要求

- 先列 findings。
- 没有 findings 时明确说明。
- 总结放在后面。
- 不要把风格建议伪装成阻塞问题。
