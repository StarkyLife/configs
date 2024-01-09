return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		"nvim-tree/nvim-web-devicons"
	},
	config = function ()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
		vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "Find in git files" })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find in buffers" })
		vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = "Find string" })
		vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = "Find string under the cursor" })
	end
}
