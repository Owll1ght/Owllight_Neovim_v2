local _dap_initialized = false
local dap = require("dap")
local dapui = require("dapui")

local function init_dap()
	if _dap_initialized then
		return
	end

	_dap_initialized = true

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

-- ========================================================================
-- DAP External Terminal Configurations
-- ========================================================================

local function set_external_terminal()
	if vim.fn.executable("wezterm") == 1 then
		return { command = "wezterm", args = { "start", "--" } }
	elseif vim.fn.executable("alacritty") == 1 then
		return { command = "alacritty", args = { "-e" } }
	elseif vim.fn.executable("kitty") == 1 then
		return { command = "kitty", args = { "--hold", "-e" } }
	end

	if Is_windows then
		if vim.fn.executable("wt.exe") == 1 then
			return { command = "wt.exe", args = { "--" } }
		elseif vim.fn.executable("pwsh") == 1 then
			return { command = "cmd.exe", args = { "/c", "start", "pwsh", "-NoProfile", "-Command" } }
		elseif vim.fn.executable("powershell") == 1 then
			return { command = "cmd.exe", args = { "/c", "start", "powershell", "-NoProfile", "-Command" } }
		else
			return { command = "cmd.exe", args = { "/c", "start", "cmd.exe", "/c" } }
		end
	elseif vim.fn.has("macunix") == 1 or vim.fn.has("mac") == 1 then
		return { command = "open", args = { "-a", "Terminal.app" } }
	else
		return { command = "xterm", args = { "-e" } }
	end
end

dap.defaults.fallback.external_terminal = set_external_terminal()
dap.defaults.fallback.force_external_terminal = true
