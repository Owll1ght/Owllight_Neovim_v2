local map = vim.keymap.set

map("n", "<leader>jb", "<cmd>:w | split | :term g++ % -g -o %:p:h/debug<CR>", { desc = "Use G++ Debug Output" })
