$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:PATH = "$scriptPath\python;$scriptPath\python\Scripts;$scriptPath\node;$scriptPath\git\cmd;$scriptPath\uv;" + $env:PATH
$env:UV_PYTHON = "$scriptPath\python\python.exe"
$env:GIT_PYTHON_GIT_EXECUTABLE = "$scriptPath\git\git.exe"
& $args