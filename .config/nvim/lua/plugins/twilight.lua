return {
    "folke/twilight.nvim",
    config = function()
        vim.keymap.set("n", "<leader>t", ":Twilight<CR>", {})
    end,
}
