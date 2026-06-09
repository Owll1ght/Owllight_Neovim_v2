vim.pack.add({
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/windwp/nvim-ts-autotag",
})

local group = vim.api.nvim_create_augroup("NvimAutopairsLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	group = group,
	once = true,
	callback = function()
		require("nvim-autopairs").setup({
			disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input", "vim" },
			disable_in_macro = true,
			ignore_next_char = [=[[%w%%%'%[%"%.%'%$]]=],
			enable_moveright = true,
		})
	end,
})

require("nvim-ts-autotag").setup({
	opts = {
		-- Defaults
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = true, -- Auto close on trailing </
	},
	-- Also override individual filetype configs, these take priority.
	-- Empty by default, useful if one of the "opts" global settings
	-- doesn't work well in a specific filetype
	per_filetype = {
		["html"] = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
		["php"] = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	},
})
