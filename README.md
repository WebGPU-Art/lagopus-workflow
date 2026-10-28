## Lagopus Workflow

> based on [Lagopus](https://github.com/WebGPU-Art/lagopus)

Demo https://r.tiye.me/Triadica/lagopus-workflow .

### Workflow

https://github.com/Triadica/lagopus-workflow

### 使用者影响

本轮升级为正式 Calcit 0.31.0。立方体、两个场景标签及状态事件保持原语义，页面报错仍通过原 bottom-tip 适配器显示。旧 `defatom` 改为 `defref`；状态游标逐元素验证为 Tag 后再写入，非法游标仍被拒绝，不用类型断言代替检查。没有改变 shader、几何数据或部署路径。

### 开发与部署迁移

工具链使用稳定 Calcit / `@calcit/procs` 0.31.0、Caps 0.1.1、Node.js 24 和 Yarn 4.18.0。依赖固定为已发布的 Lagopus 0.5.13、memof 0.0.41、quaternion 0.2.17。唯一源码快照为 `calcit.cirru`，依赖与版本维护在 `deps.cirru`；不再保留 `compact.cirru` 或 `package.cirru`，`js-out/`、`dist/` 不入库。

```sh
caps --strict --ci
corepack yarn install --immutable
caps verify --toolchain
calcit --check-only --all-defs --warn-dyn-method
calcit fix --workflow strict --verify
corepack yarn dev
```

另开终端运行 `corepack yarn watch`。生产构建使用 `corepack yarn build`；本地默认相对资源路径，CI 用 `VITE_BASE_URL` 指向 `https://cos-sh.tiye.me/WebGPU-Art/lagopus-workflow/`。仅当前 main push 上传前端 `dist/`，COS Action v1.2.0 通过 `public-base-url` 执行内置校验，不另加验证脚本。需要 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 以及原有 `rsync_private_key` secrets。原服务器前端路径与 rsync 参数不变，PR 只检查和构建，资源前缀包含 PR 编号、run ID 与 attempt。Action 使用正式 release tag，不是不可变 SHA。

页面入口复用 Lagopus 的有类型浏览器、GPU 和运行时适配层，缓存使用经运行时宿主对象检查的 `memo-object`。标签和状态事件保留原有语义，状态 cursor 在收窄前检查 List/Tag；构建错误以真实 String 转换显示。CI 同时检查全部定义和四个公开命名空间，不使用兼容模式或额外验证脚本。

本地验收：64 个全定义及完整 strict workflow 通过，14 个公开定义全部通过；严格依赖图、Vite 生产构建及真实 WebGPU 渲染、标签切换、刷新通过，浏览器 warning/error 为空。仍有 3 个定义中的 4 个开放状态 Map 类型位置，不宣称类型债务清零。生产 COS 校验和原服务器部署需由合并后的 Actions 另行验收。

### License

MIT
