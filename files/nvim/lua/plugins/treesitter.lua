return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"lua", "javascript", "bash", "python", "html", "css", "json", "yaml", "toml"},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
