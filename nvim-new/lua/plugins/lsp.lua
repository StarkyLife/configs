local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = vim.env.PATH .. ":" .. mason_bin

vim.diagnostic.config({
	virtual_text = true, -- inline error text after the line
	signs = false, -- icons in the gutter
	underline = true, -- squiggly underlines
	update_in_insert = false, -- don't flicker while typing
	severity_sort = true, -- errors before warnings
})

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
			desc = "Go to definition",
		})
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_next()
			vim.diagnostic.open_float()
		end, { buffer = ev.buf, silent = true, remap = false, desc = "Next diagnostic" })
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_prev()
			vim.diagnostic.open_float()
		end, { buffer = ev.buf, silent = true, remap = false, desc = "Prev diagnostic" })
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
