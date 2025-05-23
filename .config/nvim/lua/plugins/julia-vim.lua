return {
	"JuliaEditorSupport/julia-vim",
	config = function()
		vim.keymap.set("n", "<F7>", ":call LaTeXtoUnicode#Toggle()<CR>", {})
	end,
}
