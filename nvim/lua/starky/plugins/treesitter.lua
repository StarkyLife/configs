return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function ()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false
			},
			sync_install = false,
			auto_install = true,
			ensure_installed = {
				"json",
				"jsdoc",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"graphql",
				"bash",
				"dockerfile",
				"markdown",
				"markdown_inline",
				"xml",
				"yaml",
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
			},
		})
	end
}
