FROM python:3.12-slim

LABEL name="DouK-Downloader" authors="JoeanAmier" repository="https://github.com/JoeanAmier/TikTokDownloader"

# 设置工作目录
WORKDIR /TikTokDownloader

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 复制配置文件
COPY requirements.txt settings.example.json /TikTokDownloader/
COPY docker-entrypoint.sh /usr/local/bin/

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制项目文件
COPY src /TikTokDownloader/src
COPY locale /TikTokDownloader/locale
COPY static /TikTokDownloader/static
COPY license /TikTokDownloader/license
COPY main.py /TikTokDownloader/main.py

# 创建数据卷目录
RUN mkdir -p /TikTokDownloader/data /TikTokDownloader/downloads

# 设置启动脚本权限
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 暴露端口
EXPOSE 5555

# 设置健康检查
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5555/ || exit 1

# 设置入口点
ENTRYPOINT ["docker-entrypoint.sh"]

# 启动应用
CMD ["python", "main.py"]
