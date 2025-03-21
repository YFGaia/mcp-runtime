# mcp-runtime

**mcp-runtime** is a pre-configured runtime environment designed to simplify the setup process for running [Model Context Protocol (MCP)](https://modelcontextprotocol.io) servers on Windows. It integrates essential tools including Node.js (with `npx` and `npm`), Python (with `uv`, `uvx`, and `pip`), and Git, allowing developers to focus on building MCP-based applications, such as client Chatbot applications, without worrying about environment configuration.

**Purpose:** Many developers encounter difficulties when setting up environments for MCP servers. mcp-runtime addresses this issue by providing a portable, all-in-one solution that integrates these dependencies and ensures they are accessible through the system PATH.

**Note:** Currently, mcp-runtime only supports Windows. Support for other operating systems (such as macOS, Linux) will be added in future releases.

## Prerequisites

- **Operating System:** Windows (Windows 10 or higher recommended)

No additional software installation is required, as mcp-runtime includes all necessary tools.

## Installation

1. Download the latest version from the [GitHub repository](https://github.com/YFGaia/mcp-runtime/releases).
2. Extract the zip file to a directory of your choice, such as `C:\mcp-runtime`.

## Usage

To run an MCP server with mcp-runtime, the directories containing bundled tools (such as `python`, `node`, `git\cmd`, `uv`) must be added to the system PATH before executing server commands, and the following environment variables must be set:
- `UV_PYTHON`: pointing to `mcp-runtime\python\python.exe`
- `GIT_PYTHON_GIT_EXECUTABLE`: pointing to `mcp-runtime\git\git.exe`

For convenience, mcp-runtime provides `mcp-run.bat` (for Command Prompt) and `mcp-run.ps1` (for PowerShell) scripts that automatically handle these settings.

### Using Command Prompt

1. Open Command Prompt.
2. Navigate to the mcp-runtime directory, e.g., `cd C:\mcp-runtime`.
3. Use `mcp-run.bat` to start the MCP server. For example:

```cmd
mcp-run.bat npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir
```

### Using PowerShell

1. Open PowerShell.
2. Navigate to the mcp-runtime directory, e.g., `cd C:\mcp-runtime`.
3. Use `mcp-run.ps1` to start the MCP server. For example:

```powershell
.\mcp-run.ps1 npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir
```

### Programmatic Usage

When launching an MCP server from a program (e.g., Python, Node.js, or Go), you must programmatically set the PATH and the `UV_PYTHON` and `GIT_PYTHON_GIT_EXECUTABLE` environment variables before executing the command.

#### Node.js Example

```javascript
const { spawn } = require('child_process');
const path = require('path');

const mcpRuntimePath = 'C:\\mcp-runtime'; // Adjust to your extraction path
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

#### Python Example

```python
import os
import subprocess

mcp_runtime_path = 'C:\\mcp-runtime'  # Adjust to your extraction path
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
process.wait()  # Wait for the process to complete, or handle output as needed
```

#### Go Example

```go
package main

import (
    "os"
    "os/exec"
    "path/filepath"
    "strings"
)

func main() {
    mcpRuntimePath := `C:\mcp-runtime` // Adjust to your extraction path
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

### MCP Server Configuration Examples

MCP servers typically use JSON files for configuration, defining commands and arguments. Here are examples adjusted for Windows paths:

#### Filesystem Server (TypeScript-based)

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

Run this server using:
- Command Prompt: `mcp-run.bat npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir`
- PowerShell: `.\mcp-run.ps1 npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir`

#### Git Server (Python-based)

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

Run this server using:
- Command Prompt: `mcp-run.bat uv --directory C:\path\to\mcp-servers\mcp-servers\src\git run mcp-server-git`
- PowerShell: `.\mcp-run.ps1 uv --directory C:\path\to\mcp-servers\mcp-servers\src\git run mcp-server-git`

**Note:** Replace `C:\path\to\mcp-servers` with the actual path to your MCP server source directory.

## Recommendation
When running Python-based MCP Servers, it's recommended to first activate a virtual environment and then run the server within that environment, following the same logic as above. This helps resolve potential issues caused by different MCP Servers depending on the same package but with different versions.

## License

This project is licensed under the [MIT License](LICENSE).

## Support

For questions or concerns, please submit a report on the [GitHub Issues page](https://github.com/YFGaia/mcp-runtime/issues). 