return {
	"numToStr/FTerm.nvim",
	config = function()
		require("FTerm").setup({
			border = "double",
			dimensions = {
				height = 0.8,
				width = 0.8,
			},
		})

		-- Example keybindings
		vim.keymap.set("n", "<C-Enter>", '<CMD>lua require("FTerm").toggle()<CR>')
		vim.keymap.set("t", "<C-Enter>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
	end,
}


