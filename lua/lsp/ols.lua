-- return {
-- 	cmd = { "ols" },
-- 	filetypes = { "odin" },
-- 	init_options = {
-- 		enable_auto_import = true,
-- 		checker_args = "",
-- 	},
-- }

local M = {}

-- Detect project root (where .git or ols.json lives)
local function find_root(fname)
	local root = vim.fs.root(fname, { ".git", "ols.json" })
	return root or vim.fs.dirname(fname) -- Fallback: directory of current file
end

-- Cross-platform path joining
local function join(...)
	local sep = package.config:sub(1, 1) -- '/' on Linux, '\' on Windows
	return table.concat({ ... }, sep)
end

-- Check if a path is a valid executable file
local function is_executable(path)
	local stat = vim.uv.fs_stat(path)
	if not stat then
		return false
	end
	if stat.type ~= "file" then
		return false
	end
	-- On Windows, just check existence. On Unix, check executable bit.
	if package.config:sub(1, 1) == "\\" then
		return true
	end
	return bit.band(stat.mode, 73) ~= 0
end

-- Check if toolchain looks valid (has core/ and vendor/ dirs)
local function is_valid_toolchain(root)
	local toolchain = join(root, ".odin-toolchain")
	local core_dir = join(toolchain, "core")
	local vendor_dir = join(toolchain, "vendor")
	local bin = join(toolchain, "odin")

	local has_core = vim.uv.fs_stat(core_dir) ~= nil
	local has_vendor = vim.uv.fs_stat(vendor_dir) ~= nil
	local has_bin = is_executable(bin)

	return has_core and has_vendor and has_bin, has_core, has_vendor, has_bin
end

M.setup = function()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("OdinLSP", { clear = true }),
		pattern = "odin",
		callback = function(args)
			local bufnr = args.buf
			local fname = vim.api.nvim_buf_get_name(bufnr)
			local root = find_root(fname)
			local is_windows = package.config:sub(1, 1) == "\\"
			local path_sep = is_windows and ";" or ":"

			local env = vim.fn.environ()
			local using_local = false
			local odin_path = nil

			-- 1. Project-local toolchain
			local local_valid, has_core, has_vendor, has_bin = is_valid_toolchain(root)

			if local_valid then
				using_local = true
				local toolchain_dir = join(root, ".odin-toolchain")
				-- ODIN_ROOT must point to the directory containing core/, vendor/, base/
				env.ODIN_ROOT = toolchain_dir
				-- PATH must include the directory containing the 'odin' binary
				env.PATH = toolchain_dir .. path_sep .. (env.PATH or "")
				odin_path = join(toolchain_dir, "odin")

				vim.notify(string.format("[OLS] Using project toolchain: %s", toolchain_dir), vim.log.levels.INFO)
			else
				-- 2. System toolchain Fallback
				local system_odin = vim.fn.exepath("odin")

				if system_odin ~= "" then
					odin_path = system_odin
					-- Don't override ODIN_ROOT - let system odin use its own default
					-- or whatever the user has in the shell environment
					vim.notify(string.format("[OLS] Using system odin: %s", system_odin), vim.log.levels.INFO)
				else
					vim.notify("[OLS] ERROR: No odin binary found. Install system or local odin.", vim.log.levels.ERROR)
				end
			end

			-- Debug: Verify vendor exists
			if using_local then
				local vendor_path = join(root, ".odin-toolchain", "vendor")
				if vim.uv.fs_stat(vendor_path) == nil then
					vim.notify("[OLS] WARNING: vendor not found in toolchain.", vim.log.levels.WARN)
				end
			end

			vim.lsp.start({
				name = "ols",
				cmd = { "ols" },
				root_dir = root,
				filetypes = { "odin" },
				workspace_folders = {
					{ uri = vim.uri_from_fname(root), name = vim.fs.basename(root) },
				},
				-- OLS reads ols.json from root_dir automatically
				-- But we also pass env vars in case it needs them
				cmd_env = env,
				on_attach = function(client, buf)
					-- Your existing on_attach logic here
					-- Example: enable formatting, keymaps, etc.
					vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
				end,
				capabilities = vim.lsp.protocol.make_client_capabilities(),
			})
		end,
	})
end

return M
