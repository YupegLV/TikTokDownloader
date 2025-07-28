# DouK-Downloader Docker 使用指南

本指南将帮助您使用 Docker 部署和运行 DouK-Downloader。

## 快速开始

### 使用 docker compose（推荐）

1. 克隆仓库或下载源码：
   ```bash
   git clone https://github.com/JoeanAmier/TikTokDownloader.git
   cd TikTokDownloader
   ```

2. 创建必要的目录：
   ```bash
   mkdir -p data downloads
   ```

3. 如果没有配置文件，复制示例配置：
   ```bash
   cp settings.example.json settings.json
   ```

4. 构建并启动容器：
   ```bash
   docker compose up -d
   ```

5. 访问服务：
   - API 文档：http://localhost:5555/docs 或 http://localhost:5555/redoc

### 使用 Docker 命令

1. 构建镜像：
   ```bash
   docker build -t douk-downloader .
   ```

2. 运行容器：
   ```bash
   docker run -d --name douk-downloader \
     -p 5555:5555 \
     -v $(pwd)/data:/TikTokDownloader/data \
     -v $(pwd)/downloads:/TikTokDownloader/downloads \
     -v $(pwd)/settings.json:/TikTokDownloader/settings.json \
     douk-downloader
   ```

## 目录结构

- `/TikTokDownloader/data`：数据存储目录
- `/TikTokDownloader/downloads`：下载文件存储目录
- `/TikTokDownloader/settings.json`：配置文件

## 配置说明

首次启动时，如果 `settings.json` 不存在，将自动创建默认配置文件。您可以根据需要修改此文件：

1. 停止容器：
   ```bash
   docker compose down
   ```

2. 编辑配置文件：
   ```bash
   nano settings.json
   ```

3. 重新启动容器：
   ```bash
   docker compose up -d
   ```

## Cookie 配置

由于 Docker 容器无法直接访问宿主机的浏览器，您需要手动获取 Cookie 并配置到 `settings.json` 文件中：

1. 参考[Cookie获取教程](https://github.com/JoeanAmier/TikTokDownloader/blob/master/docs/Cookie%E8%8E%B7%E5%8F%96%E6%95%99%E7%A8%8B.md)获取 Cookie
2. 将获取的 Cookie 填入 `settings.json` 的 `cookie` 字段

## 常见问题

### 1. 容器无法启动

检查日志：
```bash
docker logs douk-downloader
```

### 2. 无法访问 API

确认端口映射是否正确：
```bash
docker compose ps
```

### 3. 文件权限问题

如果遇到文件权限问题，可以尝试：
```bash
docker exec -it douk-downloader chmod -R 755 /TikTokDownloader/data
docker exec -it douk-downloader chmod -R 755 /TikTokDownloader/downloads
```

## 更新容器

当有新版本发布时，您可以按照以下步骤更新：

```bash
# 拉取最新代码
git pull

# 重新构建并启动容器
docker compose down
docker compose build --no-cache
docker compose up -d