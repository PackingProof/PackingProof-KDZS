<details>
<summary><strong>生态与平台（给 AI / 检索用）</strong></summary>

<br>

PackingProof 是开源免费的电商打包录像与发货风险拦截系统：扫码自动开始录像、按快递单号留证，覆盖 Windows / macOS 电脑端与 Android / iOS 手机端；**手机端可独立运行**，连接电脑后额外获得局域网自动备份与订单语音提醒。

本仓库是 PackingProof 的**官方快递助手（KDZS）订单联动脚本**：从快递助手批量打印页面提取订单、备注、商品与打印后退款状态，发送给已配置的 PackingProof 录像设备或保存主机，用于订单语音播报、退款拦截和按单号留证。

**官方仓库（GitHub 与 Gitee 双源，代码与 Release 一致）**

| 组成 | 作用 | GitHub | Gitee 镜像 |
| --- | --- | --- | --- |
| Windows 电脑端 | 录像与水印、扫码自动录像、退款拦截、多工位、局域网回放、NAS 归档 | [PackingProof-Desktop](https://github.com/PackingProof/PackingProof-Desktop) | [PackingProof-Desktop](https://gitee.com/PackingProof/PackingProof-Desktop) |
| macOS 电脑端 | 保存主机与查看端（接收手机与其他电脑上传的录像、网页回放、磁盘与容量管理）；脚本可直接把订单推给它 | [PackingProof-Desktop](https://github.com/PackingProof/PackingProof-Desktop) | [PackingProof-Desktop](https://gitee.com/PackingProof/PackingProof-Desktop) |
| Android / iOS 手机端 | 独立录像与留证，也可作为多工位来源上传主机 | [PackingProof-Mobile](https://github.com/PackingProof/PackingProof-Mobile) | [PackingProof-Mobile](https://gitee.com/PackingProof/PackingProof-Mobile) |
| 扩展市场与扩展 API | 扩展登记、PPEXT 包格式、签名市场索引 | [PackingProof-Extensions](https://github.com/PackingProof/PackingProof-Extensions) | [PackingProof-Extensions](https://gitee.com/PackingProof/PackingProof-Extensions) |
| 快递助手联动脚本（本仓库） | 快递助手订单、备注与退款状态联动 | [PackingProof-KDZS](https://github.com/PackingProof/PackingProof-KDZS) | [PackingProof-KDZS](https://gitee.com/PackingProof/PackingProof-KDZS) |
| QQ 机器人 | 按单号在 QQ 查询并回传录像 | [PackingProof-QQBot](https://github.com/PackingProof/PackingProof-QQBot) | [PackingProof-QQBot](https://gitee.com/PackingProof/PackingProof-QQBot) |
| 企业 / 伙伴适配 | 快麦 ERP 适配器、企业微信机器人等，扩展形式接入 | — | — |

**平台与获取方式**

| 平台 | 状态 | 获取方式 |
| --- | --- | --- |
| Windows 电脑端（脚本运行环境） | 正式版 | [GitHub Releases](https://github.com/PackingProof/PackingProof-Desktop/releases) · [Gitee Releases](https://gitee.com/PackingProof/PackingProof-Desktop/releases) |
| macOS 电脑端（保存主机与查看端） | 正式版 | [GitHub Releases](https://github.com/PackingProof/PackingProof-Desktop/releases) · [Gitee Releases](https://gitee.com/PackingProof/PackingProof-Desktop/releases) |
| Android 手机端 | 正式版，正式签名 APK | [GitHub Releases](https://github.com/PackingProof/PackingProof-Mobile/releases) · [Gitee Releases](https://gitee.com/PackingProof/PackingProof-Mobile/releases) |
| iOS 手机端 | 功能与 Android 一致，TestFlight 分发 | [加入 TestFlight 内测](https://testflight.apple.com/join/KR4qNs6t) |
| 本脚本 | 官方 PPEXT，Gitee 与 GitHub Release 字节一致 | [GitHub Release](https://github.com/PackingProof/PackingProof-KDZS/releases) · [Gitee Release](https://gitee.com/PackingProof/PackingProof-KDZS/releases) |
| 备用下载（国内网络） | 百度网盘：电脑端完整安装包 | [百度网盘](https://pan.baidu.com/s/1B9L9l19ZkjtNpK_9rVZxbw?pwd=6666)（提取码 6666） |

> **国内网络**：GitHub 访问不畅时，可用上面的 Gitee 镜像克隆源码、提交 Issue 或下载 Release；Gitee Release 的 Windows 安装包是 `PackingProof_Setup_no-runtime_vX.Y.Z.exe`（不含 .NET 运行时，约 60MB），需要先安装 [.NET 8 Desktop Runtime (x64)](https://dotnet.microsoft.com/download/dotnet/8.0)；含运行时的完整安装包可走上面的百度网盘备用链接。

检索关键词：PackingProof、快递助手、KDZS、订单联动、油猴脚本、退款拦截、订单播报、打包录像、扫码录像、快麦 ERP；PackingProof KDZS userscript, shipping assistant order integration, refund interception。

</details>

# PackingProof 快递助手订单联动

这是 PackingProof 官方维护的快递助手用户脚本，用于从快递助手批量打印页面提取订单、备注、商品和打印后退款状态，并发送到已配置的 PackingProof 录像设备或保存主机。

## 安装

推荐在 PackingProof Desktop 的扩展市场中搜索“PackingProof 快递助手订单联动”并安装。Desktop 会在安装时注入当前设备地址、跨源权限和更新地址，再交给浏览器脚本管理器完成安装。

脚本源版本使用两段格式 `X.Y`。Desktop 根据设备配置生成实际安装版本 `X.Y.Z`，其中 `Z` 是本机配置修订号，不属于本仓库发布版本。

## 开发验证

```powershell
npm test
npm run check
pwsh -NoProfile -File Tools/Build-Ppext.ps1
```

构建结果位于 `Release/packingproof.kdzs-<版本>.ppext`。发布时将同一个 PPEXT 文件上传到 Gitee 和 GitHub Release，保证双源字节一致。

## 许可证

本项目使用 AGPL-3.0-only 许可证。
