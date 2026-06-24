vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.g.mapleader = ","
vim.g.maplocalleader = ","

Is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- Entry point for Neovim configuration
require("config")
require("plugins")

require("config.lsp")
require("dap_configs")

if Is_windows then
	vim.defer_fn(function()
		vim.opt.shellslash = false
	end, 5000)
	vim.o.shell = "powershell"
	vim.o.shellcmdflag = "-NoProfile -NoLogo -NonInteractive -Command"
	vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s"
	vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
	print("Running on Windows")
else
	print("Running on MacOS or Linux")
end
