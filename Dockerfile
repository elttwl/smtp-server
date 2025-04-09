# 使用官方 Ubuntu 镜像作为基础镜像
FROM ubuntu:24.04

LABEL maintainer="elttwl <elttwl@qq.com>"
LABEL imagename="elttwl/smtp-server"
LABEL version="2.1"
LABEL description="This is a custom SMTP server image with Postfix and Dovecot."

# 设置环境变量以避免交互式安装时的提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    postfix \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# 复制 entrypoint 脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 暴露 SMTP 端口
EXPOSE 25

# 设置 ENTRYPOINT
ENTRYPOINT ["/entrypoint.sh"]
