return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("oil").setup({
        keymaps = {
          ["<C-h>"] = false,
        },
      })

      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil" })
    end
  }
}
