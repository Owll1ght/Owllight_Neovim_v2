vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

require("mason-lspconfig").setup()

require("mason-tool-installer").setup({
	ensure_installed = {
		-- lsp
		"lua_ls",
		"roslyn",
		"clangd",

		-- formatter
		"stylua",
		"biome",
		"prettier",
		"taplo",
		"black",
		"goimports",
		"clang-format",
		"csharpier",
	},
})
