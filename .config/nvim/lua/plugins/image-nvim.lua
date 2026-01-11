return {
  {
    "3rd/image.nvim",
    build = false, -- don’t build the luarock
    opts = {
      processor = "magick_cli",

      integrations = {
        markdown = {
          enabled = true,                      -- enable markdown integration
          only_render_image_at_cursor = true,  -- only show image under cursor
          only_render_image_at_cursor_mode = "inline", -- "popup" or "inline"
          download_remote_images = true,       -- auto-download remote images
          filetypes = { "markdown", "vimwiki", "text" },
        },
      },
    },
  },
}

