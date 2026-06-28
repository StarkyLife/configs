local parsers = {
  "lua", "vim", "vimdoc", "bash", "json", "yaml",
  "markdown", "markdown_inline", "html", "css",
  "javascript", "typescript", "tsx", "dockerfile",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    config = function()
      require("nvim-treesitter").install(parsers)
    end,
  }
}
