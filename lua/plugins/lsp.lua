return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "petertriho/cmp-git"
  },
  config = function()
    servers = { "eslint", "lua_ls", "pylsp", "yamlls", "ts_ls" }


    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    vim.lsp.config('eslint', {
      settings = {
        ['eslint'] = {
          bin = 'eslint', -- or `eslint_d`
          code_actions = {
            enable = true,
            apply_on_save = {
              enable = true,
              types = { "directive", "problem", "suggestion", "layout" },
            },
            disable_rule_comment = {
              enable = true,
              location = "separate_line", -- or `same_line`
            },
          },
          diagnostics = {
            enable = true,
            report_unused_disable_directives = false,
            run_on = "type", -- or `save`
          },
        },
      },
    })

    for i, server in ipairs(servers) do
      vim.lsp.enable(server)
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    for i, server in ipairs(servers) do
      require('lspconfig')[server].setup {
        capabilities = capabilities
      }
    end

    require("mason-lspconfig").setup({})
  end
}
