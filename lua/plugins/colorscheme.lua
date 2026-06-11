require("kanagawa").setup({
	transparaent = true,
	theme = "dragon",
	background = {
		dark = "dragon",
		light = "dragon",
	},
})

vim.cmd("colorscheme kanagawa")

local map = vim.keymap.set

map("n", "<leader>ld", "<cmd>colorscheme kanagawa-dragon<cr>", { desc = "Kanagawa Dragon Colorscheme" })
map("n", "<leader>lw", "<cmd>colorscheme kanagawa-wave<cr>", { desc = "Kanagawa Wave Colorscheme" })
map("n", "<leader>ll", "<cmd>colorscheme kanagawa-lotus<cr>", { desc = "Kanagawa Lotus Colorscheme" })
