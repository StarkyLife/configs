return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			vim.cmd([[colorscheme gruvbox]])
		end,
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "auto",
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			delay = 600,
			preset = "modern",
		},
	},
}
