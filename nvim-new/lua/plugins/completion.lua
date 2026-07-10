return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local blink = require("blink.cmp")
			blink.setup({
				keymap = { preset = "enter" },
				completion = {
					menu = {
						draw = {
							columns = { { "kind_icon", "label", "label_description", gap = 1 } },
							components = {
								label_description = {
									width = { max = 30 },
									text = function(ctx)
										return ctx.label_description ~= "" and ctx.label_description
											or (ctx.item.detail or "")
									end,
									highlight = "BlinkCmpLabelDescription",
								},
							},
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
					},
				},
			})
			vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
		end,
	},
}
