# 360T7 ImmortalWrt 24.10 / Linux 6.6 / MTK mtwifi / 集客AC

本项目用于构建一份面向 **360T7（MT7981）** 的精简固件：

- 基础源码：`padavanonly/immortalwrt-mt798x-6.6`
- 分支：`openwrt-24.10-6.6`
- 无线：MTK `mtwifi` 闭源驱动
- 无线管理：`luci-app-mtwifi-cfg`
- 存储：NMBM + fixed-parts
- 集客AC：`gecoosac` + `luci-app-gecoosac`，固定版本 `V2.2.20251015`
- 默认管理地址：`192.168.6.1`
- 首次登录：用户名 `root`，默认无密码

## 与当前 Yuzhii U-Boot 的匹配关系

源码中的 `mt7981b-qihoo-360t7.dts` 包含：

```dts
mediatek,nmbm;
```

并从本机 Factory 分区读取无线校准数据：

```dts
mediatek,mtd-eeprom = <&factory 0x0>;
```

因此适合已经启用 NMBM 的 Yuzhii fixed-parts U-Boot。不要改用官方无 NMBM 的 360T7 FIT。

## GitHub Actions 编译

1. 新建一个空 GitHub 仓库。
2. 将本压缩包内所有文件上传到仓库根目录，必须保留 `.github/workflows/build.yml`。
3. 打开仓库的 **Actions**。
4. 选择 `Build 360T7 ImmortalWrt mtwifi GecoosAC`。
5. 点击 **Run workflow**。
6. 编译完成后，从 Artifacts 或 Releases 下载固件与 `sha256sums`。

工作流会自动验证：

- 目标设备是 `qihoo_360t7`
- `kmod-mt_wifi` 已编入
- `luci-app-mtwifi-cfg` 已编入
- `gecoosac` 与 `luci-app-gecoosac` 已编入
- DTS 仍包含 `mediatek,nmbm`

## 本地编译

推荐 Ubuntu 22.04、至少 4 GB 内存、40 GB 可用空间。安装 OpenWrt 构建依赖后执行：

```bash
./build-local.sh
```

固件输出目录：

```text
openwrt/bin/targets/mediatek/filogic/
```

## 刷写提醒

只刷文件名包含：

```text
qihoo_360t7
sysupgrade
```

的系统固件。不要在系统升级页面刷 BL2 或 FIP。

首次切换到这套固件建议：

- 不保留旧配置；
- 先备份 `Factory`、`factory`、`config`、BL2、FIP 和整片闪存；
- 保持串口连接观察首次启动；
- 看到 `FDT Mismatch` 时立即停止，不要强制继续启动。

## 无线性能说明

`mtwifi` 更接近 360 原厂 SDK 无线栈，但无法承诺在所有环境中与原厂完全相同。无线表现还取决于：

- 是否使用本机原始 Factory 校准数据；
- 国家/地区码、信道、带宽和功率设置；
- 终端能力、干扰和摆放位置；
- 是否使用非本机 EEPROM 或所谓高功率校准文件。

不要替换 Factory/EEPROM，也不要盲目提高发射功率。
