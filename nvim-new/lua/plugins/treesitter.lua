return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    config = function ()
      require("nvim-treesitter").install({
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "javascript",
        "typescript",
        "jsx",
        "tsx",
        "dockerfile",
      })
    end
  }
}
