local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      vim.fn.expand('~/.local/share/nvim/vscode-js-debug/js-debug/src/dapDebugServer.js'),
      '${port}',
    },
  },
}

local js_config = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Debug Jest test',
    program = '${workspaceFolder}/node_modules/.bin/jest',
    args = { '--config=jest.config.ts', '--testPathPattern=${file}', '--no-coverage', '--runInBand' },
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    skipFiles = { '<node_internals>/**' },
    env = {
      SKIP_WORKER = 'true',
      TEST_STAMP = 'dummy',
    },
  },
}

dap.configurations.typescript = js_config
dap.configurations.typescriptreact = js_config
dap.configurations.javascript = js_config

dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
