return {
    "folke/zen-mode.nvim",
    opts = {
        plugins = {
            twilight = { enabled = true },
            gitsigns = { enabled = true },
            -- this will change the font size on kitty when in zen mode
            -- to make this work, you need to set the following kitty options:
            -- - allow_remote_control socket-only
            -- - listen_on unix:/tmp/kitty
            kitty = {
                enabled = true,
                font = "+3", -- font size increment
            },
        },
    },
    -- config = function()
    --     vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", {})
    -- end,
}
