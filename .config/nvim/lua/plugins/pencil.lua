return {
    "preservim/vim-pencil",
    init = function()
        -- Default wrap mode (can be "hard" or "soft")
        vim.g["pencil#wrapModeDefault"] = "soft"

        -- Automatically enable pencil for markdown and text files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "markdown", "text" },
            callback = function()
                vim.cmd("PencilSoft")
            end,
        })
    end,
}
