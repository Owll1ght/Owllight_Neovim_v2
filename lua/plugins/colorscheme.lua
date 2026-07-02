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
