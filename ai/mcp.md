## Install local mcp server
Cline can install a mcp server by itself. Sometimes, however, the installation is not smooth due to dependencies issues that Cline cannot solve.

To put the installation under control, we'd better solve the dependency issue manually before using Cline to install a mcp server.

Below are some installation examples.

### context7
The config file to local context7 mcp server is (https://github.com/upstash/context7)

```
"mcp": {
  "servers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

The actual command is `npx @upstash/context7-mcp`. Try to run it at the terminal. If the node package is downloaed and runs without errors, then the computer has all the dependencies context7 mcp server requires. We can then go to Cline to install context7.

If  `npx @upstash/context7-mcp` command fails, manually install the dependencies. Typically, follow steps below for Ubuntu:

- `$ sudo apt update`
- `$ sudo apt install nodejs`
- `$ sudo apt install npm`   # which include npx

Then run  `npx @upstash/context7-mcp` again.