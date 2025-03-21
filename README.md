# mcp-runtime

**mcp-runtime** is a pre-configured runtime environment designed to simplify the setup process for running [Model Context Protocol (MCP)](https://modelcontextprotocol.io) servers. It integrates Node.js (including `npm` and `npx`), Python (including `uv`, `uvx`, and `pip`), Git, and other necessary tools, allowing developers to focus on building MCP-based applications, such as client Chatbot apps, without worrying about environment configuration.

**Purpose:** Many developers face difficulties setting up environments for MCP servers. mcp-runtime solves this problem by providing a portable, all-in-one solution that integrates these dependencies and ensures they are accessible via the system PATH.

## Supported Operating Systems

Currently, mcp-runtime supports the following operating systems:

- **Windows** (Windows 10 or later recommended)
- **macOS** (macOS 11.0 Big Sur or later recommended)

## Installation

1. Download the latest version from the [GitHub repository](https://github.com/YFGaia/mcp-runtime/releases).
2. Choose the appropriate version for your operating system and extract it:
   - **Windows**: Extract the zip file to your preferred directory, e.g., `C:\mcp-runtime`.
   - **macOS**: Extract the zip file to your preferred directory, e.g., `/Applications/mcp-runtime` or `~/mcp-runtime`.
3. For macOS users, you'll need to add execute permissions to the run script:
   ```bash
   chmod +x /path/to/mcp-runtime/MacOS/mcp-run.sh
   ```

## Usage

### Windows

Windows users can use the `mcp-run.bat` (Command Prompt) or `mcp-run.ps1` (PowerShell) scripts to start MCP servers. For example:

```cmd
# Command Prompt
C:\mcp-runtime\mcp-run.bat npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir

# PowerShell
C:\mcp-runtime\mcp-run.ps1 npx -y @modelcontextprotocol/server-filesystem C:\Users\username\Desktop C:\path\to\other\allowed\dir
```

### macOS

macOS users can use the `mcp-run.sh` script to start MCP servers. For example:

```bash
/path/to/mcp-runtime/MacOS/mcp-run.sh npx -y @modelcontextprotocol/server-filesystem /Users/username/Desktop /Users/username/Documents
```

## Programmatic Usage

### Windows Example

#### Node.js

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

### macOS Example

#### Node.js

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

**Note:** For more usage examples and detailed information, please refer to the platform-specific documentation:
- [Windows Documentation](Windows/README.md)
- [macOS Documentation](MacOS/README.md)

## MCP Server Configuration Examples

MCP servers are typically configured using JSON files that define commands and arguments. Here are example configurations:

### Windows Filesystem Server

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

### macOS Filesystem Server

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

## Recommendations

- **Python Virtual Environments:** When running Python-based MCP Servers, it's recommended to first create and activate a virtual environment, and then run within that environment. This helps resolve potential issues with different MCP Servers depending on the same packages but requiring different versions.
- **Regular Updates:** Regularly check for and update mcp-runtime to get the latest tools and fixes.
- **Troubleshooting:** If you encounter issues, please refer to the platform-specific troubleshooting guides.

## Troubleshooting

For detailed troubleshooting guides, please refer to the platform-specific documentation:
- [Windows Troubleshooting](Windows/README.md#troubleshooting)
- [macOS Troubleshooting](MacOS/README.md#troubleshooting)

## License

This project is licensed under the [MIT License](LICENSE).

## Support

For questions or issues, please submit a report on the [GitHub Issues page](https://github.com/YFGaia/mcp-runtime/issues).

---

[中文版文档](README-zh.md) 