#!/bin/bash
set -e

# 如果settings.json不存在，则复制示例配置
if [ ! -f /TikTokDownloader/settings.json ]; then
  echo "未检测到配置文件，正在创建默认配置..."
  cp /TikTokDownloader/settings.example.json /TikTokDownloader/settings.json
fi

# 确保数据目录存在
mkdir -p /TikTokDownloader/data
mkdir -p /TikTokDownloader/downloads

# 设置正确的权限
chmod -R 755 /TikTokDownloader/data
chmod -R 755 /TikTokDownloader/downloads

# 执行主程序
exec "$@"