# mcp-runtime

**mcp-runtime** 是一个预配置的运行时环境，旨在简化运行[模型上下文协议（MCP）](https://modelcontextprotocol.io)服务器的设置过程。它集成了Node.js（包括`npm`和`npx`）、Python（包括`uv`、`uvx`和`pip`）以及Git等必要工具，让开发者能够专注于构建基于MCP的应用，如客户端Chatbot应用，而无需为环境配置而烦恼。

**目的：** 许多开发者在为MCP服务器设置环境时遇到困难。mcp-runtime通过提供一个便携的、一体化的解决方案来解决这个问题，该方案集成了这些依赖项，并确保它们可以通过系统PATH访问。

## 支持的操作系统

目前，mcp-runtime支持以下操作系统:

- **Windows**（建议使用Windows 10或更高版本）
- **macOS**（建议使用macOS 11.0 Big Sur或更高版本）

## 安装

1. 从[GitHub仓库](https://github.com/YFGaia/mcp-runtime/releases)下载最新版本。
2. 根据您的操作系统，选择相应的版本解压：
   - **Windows**: 将zip文件解压到您选择的目录，例如`C:\mcp-runtime`。
   - **macOS**: 将zip文件解压到您选择的目录，例如`/Applications/mcp-runtime`或`~/mcp-runtime`。
3. 对于macOS用户，还需要为运行脚本添加执行权限：
   ```bash
   chmod +x /path/to/mcp-runtime/MacOS/mcp-run.sh
   ```

## 使用方法

### Windows

Windows用户可以使用`mcp-run.bat`（命令提示符）或`mcp-run.ps1`（PowerShell）脚本来启动MCP服务器。例如：

```cmd
# 命令提示符
C:\mcp-runtime\mcp-run.bat npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir

# PowerShell
C:\mcp-runtime\mcp-run.ps1 npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir
```

### macOS

macOS用户可以使用`mcp-run.sh`脚本来启动MCP服务器。例如：

```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh npx -y @modelcontextprotocol/server-filesystem /Users/username/Desktop /Users/username/Documents
```

## 编程方式使用

### Windows示例

#### Node.js

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

### macOS示例

#### Node.js

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

**注意：** 关于更多使用示例和详细信息，请参阅特定操作系统目录下的文档：
- [Windows使用文档](Windows/README-zh.md)
- [macOS使用文档](MacOS/README-zh.md)

## MCP服务器配置示例

MCP服务器通常使用JSON文件进行配置，定义命令和参数。以下是示例配置：

### Windows文件系统服务器

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "C:\\mcp-runtime\\mcp-run.bat",
      "args": [
        "npx",
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\username\\Desktop",
        "C:\\path\\to\\other\\allowed\\dir"
      ]
    }
  }
}
```

### macOS文件系统服务器

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

## 建议

- **Python虚拟环境：** 运行Python类MCP Server时，建议先启动虚拟环境，然后在虚拟环境下运行，这样可以解决不同MCP Server中依赖相同包但版本不一样导致的问题。
- **定期更新：** 定期检查并更新mcp-runtime以获取最新的工具和修复。
- **如果遇到问题：** 请查看特定操作系统的详细故障排除指南。

## 故障排除

如需详细的故障排除指南，请参阅特定操作系统的文档：
- [Windows故障排除](Windows/README-zh.md#故障排除)
- [macOS故障排除](MacOS/README-zh.md#故障排除)

## 许可证

本项目采用[MIT许可证](LICENSE)。

## 支持

如有问题或疑问，请在[GitHub问题页面](https://github.com/YFGaia/mcp-runtime/issues)提交报告。 