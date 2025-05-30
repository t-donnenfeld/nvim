return {
	{
	    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
	    -- used for completion, annotations and signatures of Neovim apis
	    'folke/lazydev.nvim',
	    ft = 'lua',
	    opts = {
	      library = {
	        -- Load luvit types when the `vim.uv` word is found
	        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
	      },
	    },
	  },
	"tpope/vim-sleuth",
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{ "<leader>ss", function() require("persistence").load() end,                desc = "Restore Session" },
			{ "<leader>sS", function() require("persistence").select() end,              desc = "Select Session" },
			{ "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
			{ "<leader>sd", function() require("persistence").stop() end,                desc = "Don't Save Session" },
		}
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'petertriho/cmp-git'
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'buffer' },
				})
			})

			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'git' },
				}, {
					{ name = 'buffer' },
				})
			})
			require("cmp_git").setup()

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{ name = 'cmdline' }
				}),
				matching = { disallow_symbol_nonprefix_matching = false }
			})

			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			for i, server in ipairs({ "eslint", "lua_ls", "pylsp", "yamlls", "ts_ls" }) do
				require('lspconfig')[server].setup {
					capabilities = capabilities
				}
			end
		end
	}
}
