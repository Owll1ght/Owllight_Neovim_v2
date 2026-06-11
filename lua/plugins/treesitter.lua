require("nvim-treesitter").setup({})
require("nvim-treesitter").install({
	"bash",
	"c",
	"c_sharp",
	"comment",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"fish",
	"gdscript",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"html",
	"ini",
	"java",
	"javadoc",
	"javascript",
	"jsdoc",
	"latex",
	"lua",
	"luadoc",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"odin",
	"php",
	"php_only",
	"phpdoc",
	"python",
	"regex",
	"rust",
	"scss",
	"svelte",
	"tsx",
	"typst",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
})

require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			["@class.outer"] = "<C-v>", -- blockwise
		},
		include_surrounding_whitespace = false,
	},
	move = {
		enable = true,
		set_jumps = true,
	},
})

-- SELECT keymaps
local sel = require("nvim-treesitter-textobjects.select")
for _, map in ipairs({
	{ { "x", "o" }, "af", "@function.outer" },
	{ { "x", "o" }, "if", "@function.inner" },
	{ { "x", "o" }, "ac", "@class.outer" },
	{ { "x", "o" }, "ic", "@class.inner" },
	{ { "x", "o" }, "aa", "@parameter.outer" },
	{ { "x", "o" }, "ia", "@parameter.inner" },
	{ { "x", "o" }, "ad", "@comment.outer" },
	{ { "x", "o" }, "as", "@statement.outer" },
}) do
	vim.keymap.set(map[1], map[2], function()
		sel.select_textobject(map[3], "textobjects")
	end, { desc = "Select" .. map[3] })
end

-- MOVE keymaps
local move = require("nvim-treesitter-textobjects.move")
for _, map in ipairs({
	{ { "n", "x", "o" }, "]m", move.goto_next_start, "@function.outer" },
	{ { "n", "x", "o" }, "[m", move.goto_previous_start, "@function.outer" },
	{ { "n", "x", "o" }, "]]", move.goto_next_start, "@class.outer" },
	{ { "n", "x", "o" }, "[[", move.goto_previous_start, "@class.outer" },
	{ { "n", "x", "o" }, "]M", move.goto_next_start, "@function.outer" },
	{ { "n", "x", "o" }, "[M", move.goto_previous_start, "@function.outer" },
	{ { "n", "x", "o" }, "]o", move.goto_next_start, { "@loop.inner", "@loop.outer" } },
	{ { "n", "x", "o" }, "[o", move.goto_previous_start, { "@loop.inner", "@loop.outer" } },
}) do
	local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
	-- build a human readable desc
	local qstr = (type(query) == "table") and table.concat(query, ",") or query
	vim.keymap.set(modes, lhs, function()
		fn(query, "textobjects")
	end, { desc = "Move to" .. qstr })
end

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" then
			local ok = pcall(function()
				vim.cmd("TSUpdate")
			end)
			if ok then
				vim.notify("TSUpdate completed succesfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function()
		local filetype = vim.bo.filetype
		if filetype and filetype ~= "" then
			local success = pcall(function()
				vim.treesitter.start()
			end)
			if not success then
				return
			end
		end
	end,
})
