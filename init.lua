vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Entry point for Neovim configuration
require "config"
require "plugins"

require "config.lsp"
