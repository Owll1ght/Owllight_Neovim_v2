local _dap_initialized = false

local function init_dap()
	if _dap_initialized then
		return
	end

	_dap_initialized = true

	local dap = require("dap")
	local dapui = require("dapui")

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
