-- Lazy load on first insert mode entry
local group = vim.api.nvim_create_augroup("LspCompletionLoad", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	-- pattern = "*",
	group = group,
	once = true,
	callback = function(args)
		require("blink.cmp").setup({
			keymap = {
				preset = "enter",
				-- ["<Tab>"] = { "select_next", "fallback" },
				-- ["<S-Tab>"] = { "select_prev", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
				use_nvim_cmp_as_default = true,
			},
			completion = {
				documentation = { auto_show = false },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						name = "Snippets",
						module = "blink.cmp.sources.snippets",
						score_offset = 3,
						opts = {
							search_paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
						},
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		})

		vim.cmd("doautocmd FileType " .. vim.bo[args.buf].filetype)
	end,
})
