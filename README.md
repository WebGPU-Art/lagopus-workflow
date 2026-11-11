## Lagopus Workflow

> based on [Lagopus](https://github.com/WebGPU-Art/lagopus)

Demo https://r.tiye.me/Triadica/lagopus-workflow .

### Workflow

https://github.com/Triadica/lagopus-workflow

### 使用者影响

使用正式 Calcit 0.41.0。立方体和两个场景按钮沿用原操作，页面报错继续通过 bottom-tip 显示。扩展示例时，场景按钮直接派发 `SceneTab`，目前只有 `:cube` 和 `:todo` 两个变体。

### 开发与部署迁移

工具链使用稳定 Calcit / `@calcit/procs` 0.41.0、Caps 0.1.1、Node.js 24 和 Yarn 4.18.0。使用已发布的 Lagopus 0.5.17、Memof 0.0.47 和 Quaternion 0.2.23。`@triadica/lagopus` 0.2.0 的 npm 运行时仍要求 Touch Control 0.0.4-a1。唯一源码快照为 `calcit.cirru`，依赖与版本维护在 `deps.cirru`；生成文件输出到 `js-out/` 和 `dist/`。

```sh
caps --strict --ci
corepack yarn install --immutable
caps verify --toolchain
calcit --check-only --all-defs --warn-dyn-method
calcit fix --workflow strict --verify
corepack yarn dev
```

另开终端运行 `corepack yarn watch`。生产构建使用 `corepack yarn build`；本地默认相对资源路径，CI 用 `VITE_BASE_URL` 指向 `https://cos-sh.tiye.me/WebGPU-Art/lagopus-workflow/`。仅当前 main push 上传前端 `dist/`，COS Action v1.2.0 通过 `public-base-url` 执行内置校验，不另加验证脚本。需要 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 以及原有 `rsync_private_key` secrets。原服务器前端路径与 rsync 参数不变，PR 只检查和构建，资源前缀包含 PR 编号、run ID 与 attempt。Action 使用正式 release tag，不是不可变 SHA。

页面入口复用 Lagopus 的浏览器、GPU 和运行时适配层，缓存使用 `memo-object`。场景状态是 `Ref<SceneTab>`，按钮回调、状态更新与渲染共用同一类型。示例移除了没有发送方的通用状态写入分支。CI 同时检查全部定义和四个公开命名空间。

本地验收覆盖全部 65 个定义、15 个公开定义、完整 strict、严格依赖图和 Vite CDN 构建。

### License

MIT
