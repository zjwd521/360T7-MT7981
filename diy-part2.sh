#!/bin/bash
set -euo pipefail

# Keep the source tree's default LAN address: 192.168.6.1.
# Give the device a clear hostname.
sed -i 's/hostname="ImmortalWrt"/hostname="360T7-AC"/' package/base-files/files/bin/config_generate 2>/dev/null || true

# Fail early if the selected 360T7 DTS loses NMBM support.
DTS="target/linux/mediatek/dts/mt7981b-qihoo-360t7.dts"
test -f "$DTS"
grep -q 'mediatek,nmbm;' "$DTS"
grep -q 'mediatek,mtd-eeprom = <&factory 0x0>;' "$DTS"
