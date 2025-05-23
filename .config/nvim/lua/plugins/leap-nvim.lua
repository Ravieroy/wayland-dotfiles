-- File: ~/.config/nvim/lua/plugins/leap.lua
return {
  'ggandor/leap.nvim',
  config = function()
    require('leap').add_default_mappings()
  end
}

