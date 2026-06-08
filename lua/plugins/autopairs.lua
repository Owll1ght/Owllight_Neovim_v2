vim.pack.add({
    "https://github.com/windwp/nvim-autopairs",
})

local group = vim.api.nvim_create_augroup("NvimAutopairsLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    group = group,
    once = true,
    callback = function()
        require("nvim-autopairs").setup({
            disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input", "vim" },
            disable_in_macro = true,
            ignore_next_char = [=[[%w%%%'%[%"%.%'%$]]=],
            enable_moveright = true,
        })
    end,
})
