-- Installing lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--keymaps.lua
require("keymaps")

-- setting up vim options
require("vim-options")

-- Setting up lazy package manager
require("lazy").setup("plugins")

-- Bufferline
vim.opt.termguicolors = true
--require("bufferline").setup({})
