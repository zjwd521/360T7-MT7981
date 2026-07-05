#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SRC_DIR:-$PWD/openwrt}"
JOBS="${JOBS:-$(nproc)}"

if [ ! -d "$SRC_DIR/.git" ]; then
  git clone --depth=1 --single-branch -b openwrt-24.10-6.6 \
    https://github.com/padavanonly/immortalwrt-mt798x-6.6 "$SRC_DIR"
fi

cd "$SRC_DIR"
"$SCRIPT_DIR/diy-part1.sh"
./scripts/feeds update -a
./scripts/feeds install -a
cp "$SCRIPT_DIR/360t7-gecoosac.config" .config
rm -rf files
cp -a "$SCRIPT_DIR/files" files
"$SCRIPT_DIR/diy-part2.sh"
make defconfig
make download -j8
make -j"$JOBS" || make -j1 V=s

echo "Firmware output: $SRC_DIR/bin/targets/mediatek/filogic/"
