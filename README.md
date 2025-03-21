# mcp-runtime

**mcp-runtime** 是一个预配置的运行时环境，旨在简化在Windows上运行[模型上下文协议（MCP）](https://modelcontextprotocol.io)服务器的设置过程。它集成了Node.js（包括`npx`和`npm`）、Python（包括`uv`、`uvx`和`pip`）以及Git等必要工具，让开发者能够专注于构建基于MCP的应用，如客户端Chatbot应用，而无需为环境配置而烦恼。

**目的：** 许多开发者在为MCP服务器设置环境时遇到困难。mcp-runtime通过提供一个便携的、一体化的解决方案来解决这个问题，该方案集成了这些依赖项，并确保它们可以通过系统PATH访问。

**注意：** 目前，mcp-runtime仅支持Windows。其他操作系统（如macOS、Linux）的支持将在未来的版本中添加。

## 先决条件

- **操作系统：** Windows（建议使用Windows 10或更高版本）

无需安装其他软件，因为mcp-runtime包含了所有必要的工具。

## 安装

1. 从[GitHub仓库](https://github.com/YFGaia/mcp-runtime/releases)下载最新版本。
2. 将zip文件解压到您选择的目录，例如`C:\mcp-runtime`。

## 使用方法

要在mcp-runtime中运行MCP服务器，必须在执行服务器命令之前将包含捆绑工具（例如`python`、`node`、`git\cmd`、`uv`）的目录添加到系统PATH中，并设置以下环境变量：

- `UV_PYTHON`：指向 `mcp-runtime\python\python.exe`
- `GIT_PYTHON_GIT_EXECUTABLE`：指向 `mcp-runtime\git\git.exe`

为了方便，mcp-runtime提供了`mcp-run.bat`（用于命令提示符）和`mcp-run.ps1`（用于PowerShell）脚本，自动处理这些设置。



### 使用命令行

1. 打开命令提示符。
2. 导航到mcp-runtime目录，例如`cd C:\mcp-runtime`。
3. 使用`mcp-run.bat`启动MCP服务器。例如：

```cmd
mcp-run.bat npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir
```

### 使用PowerShell

1. 打开PowerShell。
2. 导航到mcp-runtime目录，例如`cd C:\mcp-runtime`。
3. 使用`mcp-run.ps1`启动MCP服务器。例如：

```powershell
.\mcp-run.ps1 npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir
```

### 编程方式使用

在从程序（例如Python、Node.js或Go）启动MCP服务器时，您必须在执行命令之前以编程方式设置PATH以及`UV_PYTHON`和`GIT_PYTHON_GIT_EXECUTABLE`环境变量。

#### Node.js示例

```javascript
const { spawn } = require('child_process');
const path = require('path');

const mcpRuntimePath = 'C:\\mcp-runtime'; // 调整为您的解压路径
const pathsToAdd = [
  path.join(mcpRuntimePath, 'python'),
  path.join(mcpRuntimePath, 'python\\Scripts'),
  path.join(mcpRuntimePath, 'node'),
  path.join(mcpRuntimePath, 'git\\cmd'),
  path.join(mcpRuntimePath, 'uv')
];
const env = {
  ...process.env,
  PATH: pathsToAdd.join(';') + ';' + process.env.PATH,
  UV_PYTHON: path.join(mcpRuntimePath, 'python', 'python.exe'),
  GIT_PYTHON_GIT_EXECUTABLE: path.join(mcpRuntimePath, 'git', 'git.exe')
};

const command = 'npx';
const args = ['-y', '@modelcontextprotocol/server-filesystem', 'C:\\Users\\username\\Desktop', 'C:\\path\\to\\other\\allowed\\dir'];

const child = spawn(command, args, { env });
child.stdout.on('data', (data) => console.log(data.toString()));
child.stderr.on('data', (data) => console.error(data.toString()));
```

#### Python示例

```python
import os
import subprocess

mcp_runtime_path = 'C:\\mcp-runtime'  # 调整为您的解压路径
paths_to_add = [
    os.path.join(mcp_runtime_path, 'python'),
    os.path.join(mcp_runtime_path, 'python\\Scripts'),
    os.path.join(mcp_runtime_path, 'node'),
    os.path.join(mcp_runtime_path, 'git\\cmd'),
    os.path.join(mcp_runtime_path, 'uv')
]
env = os.environ.copy()
env['PATH'] = ';'.join(paths_to_add) + ';' + env['PATH']
env['UV_PYTHON'] = os.path.join(mcp_runtime_path, 'python', 'python.exe')
env['GIT_PYTHON_GIT_EXECUTABLE'] = os.path.join(mcp_runtime_path, 'git', 'git.exe')

command = 'npx'
args = ['-y', '@modelcontextprotocol/server-filesystem', 'C:\\Users\\username\\Desktop', 'C:\\path\\to\\other\\allowed\\dir']

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
    mcpRuntimePath := `C:\mcp-runtime` // 调整为您的解压路径
    pathsToAdd := []string{
        filepath.Join(mcpRuntimePath, "python"),
        filepath.Join(mcpRuntimePath, "python\\Scripts"),
        filepath.Join(mcpRuntimePath, "node"),
        filepath.Join(mcpRuntimePath, "git\\cmd"),
        filepath.Join(mcpRuntimePath, "uv"),
    }
    currentPath := os.Getenv("PATH")
    newPath := strings.Join(pathsToAdd, ";") + ";" + currentPath

    cmd := exec.Command("npx", "-y", "@modelcontextprotocol/server-filesystem", `C:\Users\username\Desktop`, `C:\path\to\other\allowed\dir`)
    cmd.Env = append(os.Environ(),
        "PATH="+newPath,
        "UV_PYTHON="+filepath.Join(mcpRuntimePath, "python", "python.exe"),
        "GIT_PYTHON_GIT_EXECUTABLE="+filepath.Join(mcpRuntimePath, "git", "git.exe"),
    )
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    err := cmd.Run()
    if err != nil {
        panic(err)
    }
}
```

### MCP服务器配置示例

MCP服务器通常使用JSON文件进行配置，定义命令和参数。以下是针对Windows路径调整的示例：

#### 文件系统服务器（基于TypeScript）

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\username\\Desktop",
        "C:\\path\\to\\other\\allowed\\dir"
      ]
    }
  }
}
```

使用以下命令运行此服务器：

- 命令行：`mcp-run.bat npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir`
- PowerShell：`.\mcp-run.ps1 npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir`

#### Git服务器（基于Python）

```json
{
  "mcpServers": {
    "git": {
      "command": "uv",
      "args": [
        "--directory",
        "C:\\path\\to\\mcp-servers\\mcp-servers\\src\\git",
        "run",
        "mcp-server-git"
      ]
    }
  }
}
```

使用以下命令运行此服务器：

- 命令行：`mcp-run.bat uv --directory C:\path\to\mcp-servers\mcp-servers\src\git run mcp-server-git`
- PowerShell：`.\mcp-run.ps1 uv --directory C:\path\to\mcp-servers\mcp-servers\src\git run mcp-server-git`

**注意：** 将`C:\path\to\mcp-servers`替换为您MCP服务器源目录的实际路径。

## 建议

运行python类MCP Server时，建议先启动虚拟环境，然后在虚拟环境下运行启动，其他逻辑相同。这样可以解决不同MCP Server中依赖相同包，但版本不一样导致的可能问题。

## 许可证

本项目采用[MIT许可证](LICENSE)。

## 支持

如有问题或疑问，请在[GitHub问题页面](https://github.com/YFGaia/mcp-runtime/issues)提交报告。
