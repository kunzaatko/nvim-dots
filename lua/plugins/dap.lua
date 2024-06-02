return {
  'mfussenegger/nvim-dap',
  lazy = false,
  dependencies = {
    {
      'jay-babu/mason-nvim-dap.nvim',
      dependencies = { 'nvim-dap' },
      cmd = { 'DapInstall', 'DapUninstall' },
      opts = { handlers = {} },
    },
    {
      'rcarriga/nvim-dap-ui',
      opts = { floating = { border = 'rounded' } },
      dependencies = { 'nvim-neotest/nvim-nio' },
      config = function(_, opts)
        local dap, dapui = require 'dap', require 'dapui'
        dap.listeners.after.event_initialized['dapui_config'] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
          dapui.close()
        end
        dapui.setup(opts)
      end,
    },
  },
  config = function(_, opts) end,
}
