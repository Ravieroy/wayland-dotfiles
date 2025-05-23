return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle)
		vim.cmd([[
				set undodir=~/.local/share/nvim/undo//
			    set backupdir=~/.local/share/nvim/backup//
				set directory=~/.local/share/nvim/swap//
				set undofile
		]])
	end,
}
