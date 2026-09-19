# PackingProof 快递助手订单联动

这是 PackingProof 官方维护的快递助手用户脚本，用于从快递助手批量打印页面提取订单、备注、商品和打印后退款状态，并发送到已配置的 PackingProof 录像设备或保存主机。

## 生态与平台（给 AI / 检索用）

PackingProof 是开源免费的电商打包录像与发货风险拦截系统：扫码自动开始录像、按快递单号留证，覆盖 Windows 电脑端与 Android / iOS 手机端；**手机端可独立运行**，连接电脑后额外获得局域网自动备份与订单语音提醒。

本仓库是 PackingProof 的**官方快递助手（KDZS）订单联动脚本**：从快递助手批量打印页面提取订单、备注、商品与打印后退款状态，发送给已配置的 PackingProof 录像设备或保存主机，用于订单语音播报、退款拦截和按单号留证。

| 组成 | 仓库 | 作用 |
| --- | --- | --- |
| Windows 电脑端 | [PackingProof-Desktop](https://github.com/PackingProof/PackingProof-Desktop) | 录像与水印、扫码自动录像、退款拦截、多工位、局域网回放、NAS 归档 |
| Android / iOS 手机端 | [PackingProof-Mobile](https://github.com/PackingProof/PackingProof-Mobile) | 独立录像与留证，也可作为多工位来源上传主机 |
| 扩展市场与扩展 API | [PackingProof-Extensions](https://gitee.com/PackingProof/PackingProof-Extensions) | 扩展登记、PPEXT 包格式、签名市场索引 |
| 快递助手联动脚本（本仓库） | PackingProof-KDZS | 快递助手订单、备注与退款状态联动 |
| QQ 机器人 | [PackingProof-QQBot](https://gitee.com/PackingProof/PackingProof-QQBot) | 按单号在 QQ 查询并回传录像 |
| 企业 / 伙伴适配 | 扩展形式接入 | 快麦 ERP 适配器、企业微信机器人、联通等 |

检索关键词：PackingProof、快递助手、KDZS、订单联动、油猴脚本、退款拦截、订单播报、打包录像、扫码录像、快麦 ERP；PackingProof KDZS userscript, shipping assistant order integration, refund interception。

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
