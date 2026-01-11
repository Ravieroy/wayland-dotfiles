return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  keys = {
    {
      "-",
      function()
        require("oil").open_float()
      end,
      desc = "Open Oil (float)",
    },
  },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = false,
    use_default_keymaps = true,

    float = {
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = "nil",
      win_options = {
        winblend = 0,
      },
    },

    view_options = {
      show_hidden = true,
      is_always_hidden = function(name)
        return name == ".git"
      end,
    },

    win_options = {
      wrap = false,
      signcolumn = "yes",
    },
  },
}

