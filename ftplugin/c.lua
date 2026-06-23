local map = vim.keymap.set

map("n", "<leader>jd", "<cmd>:w | split | :term gcc % -g -o %:p:h/debug<CR>", { desc = "Use GCC Debug Output" })
