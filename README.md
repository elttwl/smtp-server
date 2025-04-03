# SMTP 服务

![GitHub last commit](https://img.shields.io/github/last-commit/elttwl/smtp-server)
![Docker](https://img.shields.io/badge/Docker-v28.0.1-blue)
![Ubuntu](https://img.shields.io/badge/Ubuntu-v24.04-blue)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/elttwl/smtp-server)


本项目旨在提供一个基于 Docker 的 SMTP 服务器容器，用于发送电子邮件。它适用于开发环境、测试邮件服务或生产环境中的轻量级邮件发送需求。

---

## **目录**

1. [项目简介](#项目简介)
2. [功能特性](#功能特性)
3. [安装与使用](#安装与使用)
   - [前提条件](#前提条件)
   - [快速启动](#快速启动)

---

## **项目简介**

SMTP 容器是一个轻量级的邮件发送服务，基于 Postfix 邮件服务器构建，并通过 Docker 容器化部署。它可以轻松集成到各种应用程序中，用于发送通知邮件、验证码或其他类型的电子邮件。

---

## **功能特性**

- 基于 Postfix 的高效邮件发送服务。
- 支持 SASL 认证，确保发件人身份验证。
- 使用 Docker 容器化，便于部署和管理。
- 支持自定义域名和 MX 记录配置。
- 提供简单的日志记录功能，方便调试和监控。

---

## **安装与使用**

### **前提条件**

在开始之前，请确保您的系统满足以下条件：

- 已安装 [Docker](https://www.docker.com/)。
- 网络环境允许访问外部 DNS 和邮件服务器（如 Gmail、QQ 邮箱等）。
- 如果需要自定义域名，请确保已正确配置 DNS 记录（MX 记录）。

### **快速启动**

#### **(1) 克隆项目**

```bash
git clone https://github.com/elttwl/smtp-server.git
cd smtp-server
```

#### **(2) 构建 Docker 镜像**
```bash
./build.sh
```

##### 基础镜像
[Ubuntu](https://hub.docker.com/_/ubuntu/)

#### **(3) 启动容器**
```bash
docker compose up -d
```

##### 环境变量
编辑.env文件修改环境变量。
- `MY_USER=myuser` # SMTP用户
- `MY_PASSWORD=mypassword` # SMTP用户密码
- `MY_HOSTNAME=example.com` # SMTP主机名
- `MY_DOMAIN=example.com` # SMTP域名
- `MY_NETWORKS=0.0.0.0/0` # 允许访问的网络
