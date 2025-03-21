# mcp-runtime

**mcp-runtime** is a pre-configured runtime environment designed to simplify the setup process for running [Model Context Protocol (MCP)](https://modelcontextprotocol.io) servers on macOS. It integrates Node.js (including `npm` and `npx`), Python (including `uv`, `uvx`, and `pip`), Git, and other necessary tools, allowing developers to focus on building MCP-based applications, such as client Chatbot apps, without worrying about environment configuration.

**Purpose:** Many developers face difficulties setting up environments for MCP servers. mcp-runtime solves this problem by providing a portable, all-in-one solution that integrates these dependencies and ensures they are accessible via the system PATH.

## Prerequisites

- **Operating System:** macOS (macOS 11.0 Big Sur or later recommended)

No additional software installation is required as mcp-runtime includes all necessary tools.

## Installation

1. Download the latest version from the [GitHub repository](https://github.com/YFGaia/mcp-runtime/releases).
2. Extract the zip file to your preferred directory, such as `/Applications/mcp-runtime` or `~/mcp-runtime`.
3. Open Terminal and add execute permissions to the run script with the following command:
   ```bash
   chmod +x /path/to/mcp-runtime/MacOS/mcp-run.sh
   ```

## Usage

To run an MCP server with mcp-runtime, you need to add the directories containing bundled tools (such as `python`, `node`, `git`, `uv`) to the system PATH and set the following environment variables before executing server commands:
- `UV_PYTHON`: points to `mcp-runtime/MacOS/python/bin/python3`
- `GIT_PYTHON_GIT_EXECUTABLE`: points to `mcp-runtime/MacOS/git/bin/git`
- `NODE_PATH`: points to `mcp-runtime/MacOS/node/lib/node_modules`

For convenience, mcp-runtime provides a `mcp-run.sh` script that automatically handles these settings. The script includes special handling for npm and npx commands to ensure they run correctly.

### Using the Terminal

1. Open Terminal.
2. Use `mcp-run.sh` to start the MCP server. For example:

```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh npx -y @modelcontextprotocol/server-filesystem /Users/username/Desktop /Users/username/Documents
```

> **Note:** Replace `/path/to/mcp-runtime` with the actual path where you extracted mcp-runtime.

### Programmatic Usage

When launching an MCP server from a program (such as Python, Node.js, or Go), you must programmatically set the PATH and necessary environment variables before executing commands.

#### Node.js Example

```javascript
const { spawn } = require('child_process');
const path = require('path');

const mcpRuntimePath = '/path/to/mcp-runtime/MacOS'; // Adjust to your extraction path
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

// Note: Special handling for npm and npx commands
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

#### Python Example

```python
import os
import subprocess
import sys

mcp_runtime_path = '/path/to/mcp-runtime/MacOS'  # Adjust to your extraction path
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

# Note: Special handling for npm and npx commands
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
    mcpRuntimePath := `/path/to/mcp-runtime/MacOS` // Adjust to your extraction path
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

    // Build environment variables
    env := append(os.Environ(),
        "PATH="+newPath,
        "UV_PYTHON="+filepath.Join(mcpRuntimePath, "python", "bin", "python3"),
        "GIT_PYTHON_GIT_EXECUTABLE="+filepath.Join(mcpRuntimePath, "git", "bin", "git"),
        "NODE_PATH="+filepath.Join(mcpRuntimePath, "node", "lib", "node_modules"),
    )

    // Note: Special handling for npm and npx commands
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

### MCP Server Configuration Examples

MCP servers are typically configured using JSON files that define commands and arguments. Here are examples adjusted for macOS paths:

#### Filesystem Server (TypeScript-based)

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

Run this server with the following command:
```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh npx -y @modelcontextprotocol/server-filesystem /Users/username/Desktop /Users/username/Documents
```

#### Git Server (Python-based)

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

Run this server with the following command:
```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh uv --directory /path/to/mcp-servers/mcp-servers/src/git run mcp-server-git
```

**Note:** Replace `/path/to/mcp-servers` with the actual path to your MCP server source directory.

## Recommendations
When running Python-based MCP Servers, it's recommended to first create and activate a virtual environment, then run the server within that environment. This helps resolve potential issues with different MCP Servers depending on the same packages but requiring different versions.

Example of creating and using a virtual environment in macOS:
```bash
# Create a virtual environment
/path/to/mcp-runtime/MacOS/mcp-run.sh python3 -m venv /path/to/venv

# Activate the virtual environment
source /path/to/venv/bin/activate

# Install dependencies in the virtual environment
/path/to/mcp-runtime/MacOS/mcp-run.sh pip install -r requirements.txt

# Run the MCP server in the virtual environment
/path/to/mcp-runtime/MacOS/mcp-run.sh python3 -m your_mcp_server
```

## Troubleshooting

If you encounter issues running MCP servers, try the following steps:

1. Ensure that execute permissions are added to the `mcp-run.sh` script:
   ```bash
   chmod +x /path/to/mcp-runtime/MacOS/mcp-run.sh
   ```

2. Verify your environment variable settings:
   ```bash
   /path/to/mcp-runtime/MacOS/mcp-run.sh env | grep -E "PYTHON|GIT|NODE|PATH"
   ```

3. Check if all tools are available:
   ```bash
   /path/to/mcp-runtime/MacOS/mcp-run.sh python3 --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh node --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh git --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh uv --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh npm --version
   /path/to/mcp-runtime/MacOS/mcp-run.sh npx --version
   ```

4. Common issues:
   - **npm or npx command errors**: The mcp-run.sh script has special handling for npm and npx commands for macOS environments. If you encounter issues, check if the script is correctly calling `npm-cli.js` and `npx-cli.js`.
   - **Node.js modules not found**: Ensure that the `NODE_PATH` environment variable is correctly set.
   - **Python module errors**: Try using a virtual environment to isolate dependencies.

5. If a tool is not working properly, you may need to re-extract mcp-runtime or download an updated version.

## License

This project is licensed under the [MIT License](LICENSE).

## Support

For questions or issues, please submit a report on the [GitHub Issues page](https://github.com/YFGaia/mcp-runtime/issues). 