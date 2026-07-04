require("rose-pine").setup({
	dim_inactive_windows = false,
	enable = {
		terminal = true,
		legacy_hightlights = true,
	},
	styles = {
		bold = true,
		italic = true,
		transparency = true,
	},
})

require("cyberdream").setup({
	default = false,
	base = true,
	transparent = true,
	italic_comments = true,
	extensions = {
		telescope = true,
		notify = true,
	},
	colors = {
		light = {
			fg = "#00ffcc",
			blue = "#3a5efc",
		},
	},
})

require("kanagawa").setup({
	transparent = true,
	-- theme = "wave",
	-- background = {
	-- 	dark = "wave",
	-- 	light = "wave",
	-- },
})

require("tokyonight").setup({
	transparent = true,
	terminal_colors = true,
})

vim.g.everforest_transparent_background = 2
vim.g.gruvbox_transparent_bg = 1
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_termcolors = 16
vim.g.moonlight_contrast = true
vim.g.moonlight_disable_background = true

local theme_file = vim.fn.stdpath("data") .. "/current_theme.txt"

local function load_saved_theme()
	local file = io.open(theme_file, "r")
	if file then
		local saved_theme = file:read("*l")
		file:close()

		if saved_theme and saved_theme ~= "" then
			local ok = pcall(function()
				vim.cmd("colorscheme " .. saved_theme)
			end)

			if ok then
				return
			end
		end
	end
	vim.cmd("colorscheme kanagawa-wave")
end

load_saved_theme()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function(args)
		local file = io.open(theme_file, "w")
		if file then
			file:write(args.match)
			file:close()
		end
	end,
})

local map = vim.keymap.set

map("n", "<leader>ld", "<cmd>colorscheme kanagawa-dragon<cr>", { desc = "Kanagawa Dragon Colorscheme" })
map("n", "<leader>lw", "<cmd>colorscheme kanagawa-wave<cr>", { desc = "Kanagawa Wave Colorscheme" })
map("n", "<leader>ll", "<cmd>colorscheme kanagawa-lotus<cr>", { desc = "Kanagawa Lotus Colorscheme" })
map("n", "<leader>lf", "<cmd>echo g:colors_name<CR>", { desc = "What's the Colorscheme?" })

vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "None" })
vim.api.nvim_set_hl(0, "SnacksNormal", { bg = "None" })
vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = "None" })

local function transparent_bg()
	vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NormalNC guibg=NONE ctermbg=NONE
    highlight NormalFloat guibg=NONE ctermbg=NONE
    highlight FloatBorder guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight CursorLineNr guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight MsgArea guibg=NONE ctermbg=NONE
    highlight Pmenu guibg=NONE ctermbg=NONE
    highlight PmenuSel guibg=NONE ctermbg=NONE
    highlight TabLine guibg=NONE ctermbg=NONE
    highlight TabLineFill guibg=NONE ctermbg=NONE
    highlight StatusLine guibg=NONE ctermbg=NONE
    highlight StatusLineNC guibg=NONE ctermbg=NONE
    highlight WinSeparator guibg=NONE ctermbg=NONE
    highlight vertSplit guibg=NONE ctermbg=NONE
    highlight SnacksNormal guibg=NONE ctermbg=NONE
    highlight SnacksNormalNC guibg=NONE ctermbg=NONE
    ]])
end

transparent_bg()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = transparent_bg,
})
