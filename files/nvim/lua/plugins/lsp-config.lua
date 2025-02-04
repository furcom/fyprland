return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
         "ansiblels",
         "bashls",
         "cssls",
         "docker_compose_language_service",
         "dockerls",
         "html",
         "hyprls",
         "lua_ls",
         "jsonls",
         "pylsp",
         "ts_ls",
         "sqls",
         "yamlls"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      --lspconfig.ansiblels.setup({})
      --lspconfig.bashls.setup({})
      --lspconfig.cssls.setup({})
      --lspconfig.docker_compose_language_service.setup({})
      --lspconfig.dockerls.setup({})
      --lspconfig.html.setup({})
      --lspconfig.hyprls.setup({})
      --lspconfig.lua_ls.setup({})
      --lspconfig.jsonls.setup({})
      --lspconfig.pylsp.setup({})
      --lspconfig.sqls.setup({})
      --lspconfig.ts_ls.setup({})
      --lspconfig.yamlls.setup({})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}
