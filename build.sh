#!/bin/bash
set -e

# 定义变量（可以根据需要修改）
IMAGE_NAME="elttwl/smtp-server"  # 镜像名称
IMAGE_TAG="latest"          # 镜像标签
DOCKERFILE_PATH="."         # Dockerfile 所在目录

# 输出提示信息
echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Using Dockerfile path: ${DOCKERFILE_PATH}"

# 构建镜像
docker build \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  -f "${DOCKERFILE_PATH}/Dockerfile" \
  "${DOCKERFILE_PATH}"

# 检查镜像是否构建成功
if docker images | grep "${IMAGE_NAME}" | grep "${IMAGE_TAG}"; then
  echo "Build successful!"
else
  echo "Build failed!"
  exit 1
fi
