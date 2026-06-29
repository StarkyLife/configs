return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function ()
      local blink = require("blink.cmp")
      blink.setup({ keymap = { preset = "enter" } })
      vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
    end
  }
}
