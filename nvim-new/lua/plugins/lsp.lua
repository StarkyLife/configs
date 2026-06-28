local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = vim.env.PATH .. ":" .. mason_bin

vim.diagnostic.config({
  virtual_text = true,   -- inline error text after the line
  signs = true,          -- icons in the gutter
  underline = true,      -- squiggly underlines
  update_in_insert = false,  -- don't flicker while typing
  severity_sort = true,  -- errors before warnings
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
if capabilities.workspace then
  capabilities.workspace.didChangeWatchedFiles = nil
end

vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp", { clear = true }),
  callback = function(ev)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = ev.buf,
      silent = true,
      remap = false,
      desc = "Go to definition"
    })
  end,
})

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "eslint",
        "dockerls",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
}
