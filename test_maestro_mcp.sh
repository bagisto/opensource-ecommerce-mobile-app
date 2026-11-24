#!/bin/bash
# Test script for Maestro MCP

INIT='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
TOOLS='{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'

{
  echo "$INIT"
  sleep 3
  echo "$TOOLS"
  sleep 3
} | /Users/jitendra/.maestro/bin/maestro --udid=00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE --platform=ios mcp --working-dir=/Users/jitendra/Documents/Demo_project/Bagisto_flutter 2>/tmp/maestro_stderr.log

echo "EXIT CODE: $?"
