-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------
local mapkey = require("util.keymapper").mapvimkey

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ','

-- Disable arrow keys
map("", "<up>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")
map("", "<right>", "<nop>")

-- Clear search highlighting with <leader><leader>
map("n", "<leader><leader>", ":nohl<CR>")

-- Change split orientation
map("n", "<leader>th", "<C-w>t<C-w>K") -- change vertical to horizontal
map("n", "<leader>tv", "<C-w>t<C-w>H") -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Reload configuration without restart nvim
map("n", "<leader>r", ":so %<CR>")

-- Fast saving with <leader> and s
map("n", "<leader>s", ":w<CR>")

-- Close all windows and exit from Neovim with <leader> and q
map("n", "<leader>q", ":qa!<CR>")

-- Move  around buffers with Tab and Shift+Tab
map("n", "<Tab>", ":bn<CR>")
map("n", "<S-Tab>", ":bp<CR>")

-- delete buffer
map("n", "<leader>d", ":confirm bd<CR>")

-- visual shifting (does not exit Visual mode)
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

map("v", ">", ">gv")
map("v", "<", "<gv")

-- copy to clipboard
map("v", "<leader>y", '"+y')

-- Window Management
mapkey("<leader>sv", "vsplit", "n") -- Split Vertically
mapkey("<leader>sh", "split", "n") -- Split Horizontally
mapkey("<C-Up>", "resize +2", "n")
mapkey("<C-Down>", "resize -2", "n")
mapkey("<C-Left>", "vertical resize +2", "n")
mapkey("<C-Right>", "vertical resize -2", "n")

-- Show Full File-Path
mapkey("<leader>pa", "echo expand('%:p')", "n") -- Show Full File Path

-- Replace the selection with yanked content
map("v", "<leader>r", "\"_dP")

-- use enter key to add a empty line
map("n", "<Enter>", "i<Enter><Esc>k$")

-- use leader + o/O to add new line and stay in normal mode
map("n", "<leader>o", "o<Esc>0\"_D")
map("n", "<leader>O", "o<Esc>0\"_D")

-- paste in new line
map("n", "<leader>p", ":pu<CR>")
map("n", "<leader>P", ":pu!<CR>")

-- Center buffer while navigating
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "{", "{zz")
map("n", "}", "}zz")
map("n", "N", "Nzz")
map("n", "n", "nzz")
map("n", "G", "Gzz")
map("n", "gg", "ggzz")
map("n", "<C-i>", "<C-i>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "%", "%zz")
map("n", "*", "*zz")
map("n", "#", "#zz")
-- Press 'H', 'L' to jump to start/end of a line (first/last char)
map("n", "L", "$")
map("n", "H", "^")

-- Resize split windows to be equal size
map("n", "<leader>=", "<C-w>=")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
map("v", "L", "$<left>")
map("v", "H", "^")

