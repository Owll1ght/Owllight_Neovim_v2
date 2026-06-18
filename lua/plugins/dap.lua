local _dap_initialized = false

local function init_dap()
	if _dap_initialized then
		return
	end

	_dap_initialized = true

	local dap = require("dap")
	local dapui = require("dapui")

	-- *******************************************************************************
	-- C# Debugger
	-- *******************************************************************************

	-- ====================================
	-- Helper : Fix slashes for Windows
	-- ====================================

	local function normalize_path(path)
		if Is_windows then
			local fixed_path = path:gsub("/", "\\")
			if fixed_path:match("^[a-z]:") then
				fixed_path = fixed_path:gsub("^([a-z]):", string.upper)
			end
			return fixed_path
		end
		return path
	end

	-- ====================================
	-- Helper : Find the root directory
	-- ====================================

	local function get_project_root()
		-- Start from the directory of the file you currently have open
		local current_file_dir = vim.fn.expand("%:p:h")
		-- Search upward (the ';' means search upward) for any .csproj file
		local csproj_file = vim.fn.findfile("*.csproj", current_file_dir .. ";")
		local godotproj_file = vim.fn.findfile("project.godot", current_file_dir .. ";")

		if csproj_file ~= "" then
			-- If found, return the folder containing the .csproj
			---@cast csproj_file string
			return vim.fn.fnamemodify(csproj_file, ":p:h")
		elseif godotproj_file ~= "" then
			---@cast godotproj_file string
			return vim.fn.fnamemodify(godotproj_file, ":p:h")
		end

		return vim.fn.getcwd()
	end

	-- ====================================
	-- .NET / C# Configuration (netcoredbg)
	-- ====================================

	local windows_debugger_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg"
	local non_windows_debugger_path = vim.fn.exepath("netcoredbg")

	if Is_windows then
		Debugger_path = windows_debugger_path .. ".exe"
	elseif not Is_windows then
		Debugger_path = non_windows_debugger_path
	end

	dap.adapters.coreclr = {
		type = "executable",
		-- Ensure the executable path is normalized
		command = normalize_path(Debugger_path),
		args = { "--interpreter=vscode" },
		options = {
			detached = not Is_windows,
		},
	}

	dap.adapters.netcoredbg = {
		type = "executable",
		command = normalize_path(Debugger_path),
		args = { "--interpreter=vscode" },
		options = {
			detached = not Is_windows,
		},
	}

	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			console = "integratedConsole",
			stopAtEntry = true, -- Stops code stepping right at the start
			justMyCode = true, -- Solve the problem for opening the file using nvim . or telescope
			env = {
				ASPENTCORE_ENVIRONMENT = "Development",
			},
			cwd = function()
				-- Ensure the project root path is normalized
				return vim.fn.fnamemodify(get_project_root(), ":p")
			end,
			sourceFileMap = {
				[vim.fn.fnamemodify(get_project_root(), ":p")] = vim.fn.fnamemodify(get_project_root(), ":p"),
			},
			program = function()
				local project_root = vim.fn.fnamemodify(get_project_root(), ":p")

				-- Try to automatically find the dll in the bin/Debug folder
				local dll_paths = vim.fn.glob(project_root .. "bin/Debug/**/*.dll", true, true)

				local default_path = project_root .. "/bin/Debug/"
				if #dll_paths > 0 then
					-- Pre-fill with the first found dll to save time
					default_path = dll_paths[1]
				end

				if #dll_paths == 0 then
					vim.notify("No DLLs found in " .. project_root .. "bin/Debug/", vim.log.levels.ERROR)
					return ""
				end

				local target_path = vim.fn.input("Path to dll: ", default_path, "file")

				-- STRICT SAFETY CHECK: Prevent accidental folder submission
				if vim.fn.isdirectory(target_path) == 1 then
					vim.notify(
						"ERROR: You provided a directory, not a .dll file! Debugger aborting.",
						vim.log.levels.ERROR
					)
					return ""
				end

				print("Project Root detected as: " .. get_project_root())
				-- Ensure the final .dll path is normalized
				return normalize_path(target_path)
			end,
		},
	}

	-- *******************************************************************************
	-- C# Debugger Ends
	-- *******************************************************************************

	-- ===============================================================================

	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
		controls = {
			icons = {
				pause = "⏸",
				play = "▶",
				step_into = "⏎",
				step_over = "⏭",
				step_out = "⏮",
				step_back = "b",
				run_last = "▶▶",
				terminate = "⏹",
				disconnect = "⏏",
			},
		},
	})

	-- Auto-open/close UI
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.disconnect["dapui_config"] = function()
		dapui.close({})
	end

	-- Virtual Text
	require("nvim-dap-virtual-text").setup()
end

-- Keymaps
local maps = vim.keymap.set
maps("n", "<leader>db", function()
	init_dap()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

maps("n", "<leader>dB", function()
	init_dap()
	require("dap").list_breakpoints()
	vim.cmd("copen")
end, { desc = "List Breakpoints" })

maps("n", "<leader>dc", function()
	init_dap()
	require("dap").continue()
end, { desc = "Run/Continue" })

maps("n", "<leader>dC", function()
	init_dap()
	require("dap").run_to_cursor()
end, { desc = "Run to Cursor" })

maps("n", "<leader>dg", function()
	init_dap()
	require("dap").goto_()
end, { desc = "Go to Line (No Execute)" })

maps("n", "<leader>di", function()
	init_dap()
	require("dap").step_into()
end, { desc = "Step Into" })

maps("n", "<leader>dj", function()
	init_dap()
	require("dap").down()
end, { desc = "Down" })

maps("n", "<leader>dk", function()
	init_dap()
	require("dap").up()
end, { desc = "Up" })

maps("n", "<leader>dl", function()
	init_dap()
	require("dap").run_last()
end, { desc = "Run Last" })

maps("n", "<leader>do", function()
	init_dap()
	require("dap").step_out()
end, { desc = "Step Out" })

maps("n", "<leader>dO", function()
	init_dap()
	require("dap").step_over()
end, { desc = "Step Over" })

maps("n", "<leader>dP", function()
	init_dap()
	require("dap").pause()
end, { desc = "Pause" })

maps("n", "<leader>dr", function()
	init_dap()
	require("dap").repl.toggle()
end, { desc = "Toggle REPL" })

maps("n", "<leader>ds", function()
	init_dap()
	require("dap").session()
end, { desc = "Session" })

maps("n", "<leader>dt", function()
	init_dap()
	require("dap").terminate()
	vim.defer_fn(function()
		require("dapui").close({})
	end, 100)
end, { desc = "Terminate" })

maps("n", "<leader>dw", function()
	init_dap()
	require("dap.ui.widgets").hover()
end, { desc = "DAP Widgets" })

maps("n", "<leader>du", function()
	init_dap()
	require("dapui").toggle({})
end, { desc = "DAP UI" })
