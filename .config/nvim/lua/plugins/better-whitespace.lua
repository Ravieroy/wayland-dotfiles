return {
    "ntpeters/vim-better-whitespace",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.g.better_whitespace_enabled = 1
        vim.g.strip_whitespace_on_save = 1
        vim.g.strip_only_modified_lines = 1
        vim.g.show_spaces_that_precede_tabs = 1
        vim.g.strip_whitespace_confirm = 0

        -- Delay setting highlight so it isn't overwritten by colorscheme
        vim.defer_fn(function()
            vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "#cba6f7" })
        end, 0)
    end,
}
