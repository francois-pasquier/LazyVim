local servers = require("user.plugins.lsp.servers")

local function on_attach(client, bufnr)
  require("user.plugins.lsp.format").on_attach(client, bufnr)
  require("user.plugins.lsp.keymaps").on_attach(client, bufnr)
end

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", config = true },
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim", config = { ensure_installed = vim.tbl_keys(servers) } },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      for server, opts in pairs(servers) do
        opts.capabilities = capabilities
        opts.on_attach = on_attach
        require("lspconfig")[server].setup(opts)
      end
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        on_attach = on_attach,
        sources = {
          -- nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.flake8,
        },
      })
    end,
  },
}