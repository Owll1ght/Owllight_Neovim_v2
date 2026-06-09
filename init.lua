vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = ","
vim.g.maplocalleader = ","

local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- Entry point for Neovim configuration
require("config")
require("plugins")

require("config.lsp")

if is_windows then
	vim.opt.shellslash = false
	print("Running on Windows")
else
	print("Running on MacOS or Linux")
end
