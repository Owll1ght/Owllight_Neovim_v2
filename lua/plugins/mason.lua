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
		"ols",
		"basedpyright",
		"jsonls",

		-- formatter
		"stylua",
		"biome",
		"prettier",
		"taplo",
		"black",
		"goimports",
		"clang-format",
		"csharpier",

		-- debugger
		"netcoredbg",
		"codelldb",
	},
})
