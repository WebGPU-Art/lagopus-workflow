## Lagopus Workflow

> based on [Lagopus](https://github.com/Triadica/lagopus)

Demo https://r.tiye.me/Triadica/lagopus-workflow .

### Workflow

https://github.com/Triadica/lagopus-workflow

### 开发与部署迁移

工具链使用正式 Calcit / `@calcit/procs` 0.28.0、Caps 0.1.1、Node.js 24 和 Yarn 4.18.0。唯一源码快照为 `calcit.cirru`，依赖与版本维护在 `deps.cirru`；不再保留 `compact.cirru` 或 `package.cirru`，`js-out/`、`dist/` 不入库。

```sh
caps --ci
corepack yarn install --immutable
caps verify --toolchain
calcit --check-only --warn-dyn-method
corepack yarn dev
```

另开终端运行 `corepack yarn watch`。生产构建使用 `corepack yarn build`；本地默认相对资源路径，CI 用 `VITE_BASE_URL` 指向 `https://cos-sh.tiye.me/WebGPU-Art/lagopus-workflow/`。仅当前 main push 上传前端 `dist/`，COS Action v1.2.0 通过 `public-base-url` 执行内置校验，不另加验证脚本。需要 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 以及原有 `rsync_private_key` secrets。原服务器前端路径与 rsync 参数不变，PR 只检查和构建，资源前缀包含 PR 编号、run ID 与 attempt。Action 使用正式 release tag，不是不可变 SHA。

本轮为未完成的迁移候选：Lagopus 最新正式版本 0.5.9 仍使用 Calcit 0.9.6、旧 `:configs` 快照与 `main` 依赖，0.28 的完整严格检查及构建会被依赖加载门禁阻止。待 Lagopus 发布兼容的正式版本，再更新 `deps.cirru` 并完成源码、构建和 WebGPU 实机验收；不使用 hash、修改模块缓存或关闭类型检查绕过。此阶段的 watcher / dispatch 契约不代表整个应用已通过类型检查。

### License

MIT
