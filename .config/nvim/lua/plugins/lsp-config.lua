return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"julials",
				"pylsp",
				"marksman", -- Markdown
				"ltex", -- grammar/spell-check
				"typos_lsp", -- typo/spell-check
			},
			automatic_enable = false, -- keep manual control
		},
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		opts = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			return {
				-- global defaults applied to all servers
				["*"] = {
					capabilities = capabilities,
				},

				-- per-server configs
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
						},
					},
				},

				julials = {},

				pylsp = {},

				marksman = {},

				ltex = {
					settings = {
						ltex = {
							language = "en-US",
							enabled = { "markdown", "text", "tex" },
							dictionary = {
								["en-US"] = { "Neovim", "lua_ls", "mason" },
							},
							disabledRules = { ["en-US"] = { "EN_QUOTES" } },
						},
					},
				},

				typos_lsp = {},
			}
		end,
		config = function(_, opts)
			-- Register configs
			for server, server_opts in pairs(opts) do
				vim.lsp.config(server, server_opts)
			end

			-- Manually enable servers (since automatic_enable = false)
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("julials")
			vim.lsp.enable("pylsp")
			vim.lsp.enable("marksman")
			vim.lsp.enable("ltex")
			vim.lsp.enable("typos_lsp")

			-- Diagnostics config
			vim.diagnostic.config({
				virtual_text = false,
				underline = true,
				signs = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Buffer-local keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user_lsp_config", { clear = true }),
				callback = function(args)
					local bufnr = args.buf
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Definition" })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = bufnr, desc = "LSP: Code Action" }
					)
				end,
			})
		end,
	},
}
