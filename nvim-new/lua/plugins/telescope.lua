return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function ()
      require("telescope").setup()

      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>fg', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = "Find string under the cursor" })
    end
  }
}
