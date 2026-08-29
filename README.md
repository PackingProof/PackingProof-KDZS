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

