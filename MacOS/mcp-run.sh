#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 配置要添加到PATH的路径
PATHS_TO_ADD=(
  "$SCRIPT_DIR/python"
  "$SCRIPT_DIR/python/bin"
  "$SCRIPT_DIR/node"
  "$SCRIPT_DIR/node/bin"
  "$SCRIPT_DIR/git"
  "$SCRIPT_DIR/git/bin"
  "$SCRIPT_DIR/uv"
  "$SCRIPT_DIR/uv/bin"
)

# 设置临时PATH环境变量
export PATH=$(IFS=:; echo "${PATHS_TO_ADD[*]}"):$PATH

# 设置其他必要的环境变量
export UV_PYTHON="$SCRIPT_DIR/python/bin/python3"
export GIT_PYTHON_GIT_EXECUTABLE="$SCRIPT_DIR/git/bin/git"

# 设置Node.js相关环境变量
export NODE_PATH="$SCRIPT_DIR/node/lib/node_modules"

# 检查是否需要运行npm或npx
if [ "$1" = "npm" ]; then
  shift
  "$SCRIPT_DIR/node/bin/node" "$SCRIPT_DIR/node/lib/node_modules/npm/bin/npm-cli.js" "$@"
elif [ "$1" = "npx" ]; then
  shift
  "$SCRIPT_DIR/node/bin/node" "$SCRIPT_DIR/node/lib/node_modules/npm/bin/npx-cli.js" "$@"
else
  # 运行其他传入的命令
  exec "$@"
fi 