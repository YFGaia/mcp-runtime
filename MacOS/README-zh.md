# mcp-runtime

**mcp-runtime** 是一个预配置的运行时环境，旨在简化在macOS上运行[模型上下文协议（MCP）](https://modelcontextprotocol.io)服务器的设置过程。它集成了Node.js（包括`npm`和`npx`）、Python（包括`uv`、`uvx`和`pip`）以及Git等必要工具，让开发者能够专注于构建基于MCP的应用，如客户端Chatbot应用，而无需为环境配置而烦恼。

**目的：** 许多开发者在为MCP服务器设置环境时遇到困难。mcp-runtime通过提供一个便携的、一体化的解决方案来解决这个问题，该方案集成了这些依赖项，并确保它们可以通过系统PATH访问。

## 先决条件

- **操作系统：** macOS（建议使用macOS 11.0 Big Sur或更高版本）

无需安装其他软件，因为mcp-runtime包含了所有必要的工具。

## 安装

1. 从[GitHub仓库](https://github.com/YFGaia/mcp-runtime/releases)下载最新版本。
2. 将zip文件解压到您选择的目录，例如`/Applications/mcp-runtime`或`~/mcp-runtime`。
3. 打开终端，并通过以下命令为运行脚本添加执行权限：
   ```bash
   chmod +x /path/to/mcp-runtime/MacOS/mcp-run.sh
   ```

## 使用方法

要在mcp-runtime中运行MCP服务器，必须在执行服务器命令之前将包含捆绑工具（例如`python`、`node`、`git`、`uv`）的目录添加到系统PATH中，并设置以下环境变量：
- `UV_PYTHON`：指向 `mcp-runtime/MacOS/python/bin/python3`
- `GIT_PYTHON_GIT_EXECUTABLE`：指向 `mcp-runtime/MacOS/git/bin/git`
- `NODE_PATH`：指向 `mcp-runtime/MacOS/node/lib/node_modules`

为了方便，mcp-runtime提供了`mcp-run.sh`脚本，自动处理这些设置。该脚本会特殊处理npm和npx命令，确保它们能正确执行。

### 使用终端

1. 打开终端。
2. 使用`mcp-run.sh`启动MCP服务器。例如：

```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh npx -y @modelcontextprotocol/server-filesystem /Users/username/Desktop /Users/username/Documents
```

> **注意：** 将路径中的 `/path/to/mcp-runtime` 替换为您实际解压缩mcp-runtime的路径。

### 编程方式使用

在从程序（例如Python、Node.js或Go）启动MCP服务器时，您必须在执行命令之前以编程方式设置PATH以及必要的环境变量。

#### Node.js示例

```javascript
const { spawn } = require('child_process');
const path = require('path');

const mcpRuntimePath = '/path/to/mcp-runtime/MacOS'; // 调整为您的解压路径
const pathsToAdd = [
  path.join(mcpRuntimePath, 'python'),
  path.join(mcpRuntimePath, 'python/bin'),
  path.join(mcpRuntimePath, 'node'),
  path.join(mcpRuntimePath, 'node/bin'),
  path.join(mcpRuntimePath, 'git'),
  path.join(mcpRuntimePath, 'git/bin'),
  path.join(mcpRuntimePath, 'uv'),
  path.join(mcpRuntimePath, 'uv/bin')
];
const env = {
  ...process.env,
  PATH: pathsToAdd.join(':') + ':' + process.env.PATH,
  UV_PYTHON: path.join(mcpRuntimePath, 'python', 'bin', 'python3'),
  GIT_PYTHON_GIT_EXECUTABLE: path.join(mcpRuntimePath, 'git', 'bin', 'git'),
  NODE_PATH: path.join(mcpRuntimePath, 'node', 'lib', 'node_modules')
};

// 注意：对于npm和npx命令，需要特殊处理
let command, args;
if (process.argv[2] === 'npm') {
  command = path.join(mcpRuntimePath, 'node', 'bin', 'node');
  args = [
    path.join(mcpRuntimePath, 'node', 'lib', 'node_modules', 'npm', 'bin', 'npm-cli.js'),
    ...process.argv.slice(3)
  ];
} else if (process.argv[2] === 'npx') {
  command = path.join(mcpRuntimePath, 'node', 'bin', 'node');
  args = [
    path.join(mcpRuntimePath, 'node', 'lib', 'node_modules', 'npm', 'bin', 'npx-cli.js'),
    ...process.argv.slice(3)
  ];
} else {
  command = process.argv[2];
  args = process.argv.slice(3);
}

const child = spawn(command, args, { env });
child.stdout.on('data', (data) => console.log(data.toString()));
child.stderr.on('data', (data) => console.error(data.toString()));
```

#### Python示例

```python
import os
import subprocess
import sys

mcp_runtime_path = '/path/to/mcp-runtime/MacOS'  # 调整为您的解压路径
paths_to_add = [
    os.path.join(mcp_runtime_path, 'python'),
    os.path.join(mcp_runtime_path, 'python/bin'),
    os.path.join(mcp_runtime_path, 'node'),
    os.path.join(mcp_runtime_path, 'node/bin'),
    os.path.join(mcp_runtime_path, 'git'),
    os.path.join(mcp_runtime_path, 'git/bin'),
    os.path.join(mcp_runtime_path, 'uv'),
    os.path.join(mcp_runtime_path, 'uv/bin')
]
env = os.environ.copy()
env['PATH'] = ':'.join(paths_to_add) + ':' + env['PATH']
env['UV_PYTHON'] = os.path.join(mcp_runtime_path, 'python', 'bin', 'python3')
env['GIT_PYTHON_GIT_EXECUTABLE'] = os.path.join(mcp_runtime_path, 'git', 'bin', 'git')
env['NODE_PATH'] = os.path.join(mcp_runtime_path, 'node', 'lib', 'node_modules')

# 注意：对于npm和npx命令，需要特殊处理
command_name = sys.argv[1] if len(sys.argv) > 1 else ''
if command_name == 'npm':
    command = os.path.join(mcp_runtime_path, 'node', 'bin', 'node')
    args = [
        os.path.join(mcp_runtime_path, 'node', 'lib', 'node_modules', 'npm', 'bin', 'npm-cli.js')
    ] + sys.argv[2:]
elif command_name == 'npx':
    command = os.path.join(mcp_runtime_path, 'node', 'bin', 'node')
    args = [
        os.path.join(mcp_runtime_path, 'node', 'lib', 'node_modules', 'npm', 'bin', 'npx-cli.js')
    ] + sys.argv[2:]
else:
    command = command_name
    args = sys.argv[2:]

process = subprocess.Popen([command] + args, env=env)
process.wait()  # 等待进程完成，或根据需要处理输出
```

#### Go示例

```go
package main

import (
    "os"
    "os/exec"
    "path/filepath"
    "strings"
)

func main() {
    mcpRuntimePath := `/path/to/mcp-runtime/MacOS` // 调整为您的解压路径
    pathsToAdd := []string{
        filepath.Join(mcpRuntimePath, "python"),
        filepath.Join(mcpRuntimePath, "python/bin"),
        filepath.Join(mcpRuntimePath, "node"),
        filepath.Join(mcpRuntimePath, "node/bin"),
        filepath.Join(mcpRuntimePath, "git"),
        filepath.Join(mcpRuntimePath, "git/bin"),
        filepath.Join(mcpRuntimePath, "uv"),
        filepath.Join(mcpRuntimePath, "uv/bin"),
    }
    currentPath := os.Getenv("PATH")
    newPath := strings.Join(pathsToAdd, ":") + ":" + currentPath

    // 构建环境变量
    env := append(os.Environ(),
        "PATH="+newPath,
        "UV_PYTHON="+filepath.Join(mcpRuntimePath, "python", "bin", "python3"),
        "GIT_PYTHON_GIT_EXECUTABLE="+filepath.Join(mcpRuntimePath, "git", "bin", "git"),
        "NODE_PATH="+filepath.Join(mcpRuntimePath, "node", "lib", "node_modules"),
    )

    // 注意：对于npm和npx命令，需要特殊处理
    var cmd *exec.Cmd
    if len(os.Args) > 1 {
        if os.Args[1] == "npm" {
            nodePath := filepath.Join(mcpRuntimePath, "node", "bin", "node")
            npmCliPath := filepath.Join(mcpRuntimePath, "node", "lib", "node_modules", "npm", "bin", "npm-cli.js")
            cmd = exec.Command(nodePath, append([]string{npmCliPath}, os.Args[2:]...)...)
        } else if os.Args[1] == "npx" {
            nodePath := filepath.Join(mcpRuntimePath, "node", "bin", "node")
            npxCliPath := filepath.Join(mcpRuntimePath, "node", "lib", "node_modules", "npm", "bin", "npx-cli.js")
            cmd = exec.Command(nodePath, append([]string{npxCliPath}, os.Args[2:]...)...)
        } else {
            cmd = exec.Command(os.Args[1], os.Args[2:]...)
        }
    }

    cmd.Env = env
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    err := cmd.Run()
    if err != nil {
        panic(err)
    }
}
```

### MCP服务器配置示例

MCP服务器通常使用JSON文件进行配置，定义命令和参数。以下是针对macOS路径调整的示例：

#### 文件系统服务器（基于TypeScript）

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "/path/to/mcp-runtime/MacOS/mcp-run.sh",
      "args": [
        "npx",
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/Desktop",
        "/Users/username/Documents"
      ]
    }
  }
}
```

使用以下命令运行此服务器：
```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh npx -y @modelcontextprotocol/server-filesystem /Users/username/Desktop /Users/username/Documents
```

#### Git服务器（基于Python）

```json
{
  "mcpServers": {
    "git": {
      "command": "/path/to/mcp-runtime/MacOS/mcp-run.sh",
      "args": [
        "uv",
        "--directory",
        "/path/to/mcp-servers/mcp-servers/src/git",
        "run",
        "mcp-server-git"
      ]
    }
  }
}
```

使用以下命令运行此服务器：
```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh uv --directory /path/to/mcp-servers/mcp-servers/src/git run mcp-server-git
```

**注意：** 将`/path/to/mcp-servers`替换为您MCP服务器源目录的实际路径。

## 建议
运行python类MCP Server时，建议先启动虚拟环境，然后在虚拟环境下运行启动，其他逻辑相同。这样可以解决不同MCP Server中依赖相同包，但版本不一样导致的可能问题。

macOS中创建和使用虚拟环境的示例：
```bash
# 创建虚拟环境
/path/to/mcp-runtime/MacOS/mcp-run.sh python3 -m venv /path/to/venv

# 激活虚拟环境
source /path/to/venv/bin/activate

# 在虚拟环境中安装依赖
/path/to/mcp-runtime/MacOS/mcp-run.sh pip install -r requirements.txt

# 在虚拟环境中运行MCP服务器
/path/to/mcp-runtime/MacOS/mcp-run.sh python3 -m your_mcp_server
```

## 故障排除

如果您在运行MCP服务器时遇到问题，请尝试以下步骤：

1. 确保已为`mcp-run.sh`脚本添加执行权限：
   ```bash
   chmod +x /path/to/mcp-runtime/MacOS/mcp-run.sh
   ```

2. 验证您的环境变量设置：
   ```bash
   /path/to/mcp-runtime/MacOS/mcp-run.sh env | grep -E "PYTHON|GIT|NODE|PATH"
   ```

3. 检查各工具是否可用：
   ```bash
   /path/to/mcp-runtime/MacOS/mcp-run.sh python3 --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh node --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh git --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh uv --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh npm --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh npx --version
   ```

4. 常见问题：
   - **npm或npx命令出错**：mcp-run.sh脚本已针对macOS环境特别处理了npm和npx命令。如果遇到问题，请检查脚本是否正确调用了`npm-cli.js`和`npx-cli.js`。
   - **找不到Node.js模块**：确保正确设置了`NODE_PATH`环境变量。
   - **运行python模块出错**：尝试使用虚拟环境隔离依赖。

5. 如果某个工具无法正常工作，可能需要重新解压缩mcp-runtime或下载更新版本。

## 许可证

本项目采用[MIT许可证](LICENSE)。

## 支持

如有问题或疑问，请在[GitHub问题页面](https://github.com/YFGaia/mcp-runtime/issues)提交报告。 