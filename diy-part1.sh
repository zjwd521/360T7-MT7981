#!/bin/bash
set -euo pipefail

# Add the pinned Gecoos AC controller source before feeds are installed.
rm -rf package/openwrt-gecoosac
git clone --depth=1 --branch V2.2.20251015 \
  https://github.com/laipeng668/luci-app-gecoosac.git \
  package/openwrt-gecoosac
