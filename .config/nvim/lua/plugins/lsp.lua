local servers = {
  "basedpyright", "ruff",                          -- Python
  "vtsls", "eslint", "html", "cssls", "jsonls",    -- JS / TS / web
  "jdtls",                                         -- Java
  "clangd",                                        -- C
  "marksman",                                      -- Markdown
  "lua_ls",                                        -- Lua (this config)
}

return {
  -- Neovim API completion when editing this config
  { "folke/lazydev.nvim", ft = "lua", opts = {
    library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } }, { path = "snacks.nvim", words = { "Snacks" } } },
  } },

  { "mason-org/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" }, opts = { ui = { border = "rounded" } } },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup()

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      -- Let ruff own linting/imports; basedpyright does types only
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = { typeCheckingMode = "standard" },
          },
        },
      })
      vim.lsp.config("ruff", {
        on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      })
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
        init_options = { fallbackFlags = { "-Wall", "-Wextra", "-std=c17" } },
      })
      vim.lsp.config("lua_ls", {
        settings = { Lua = { completion = { callSnippet = "Replace" }, hint = { enable = true } } },
      })

      -- Installs missing servers and enables all of them
      require("mason-lspconfig").setup({ ensure_installed = servers, automatic_enable = true })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = true },
        underline = true,
        virtual_text = { spacing = 2, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(ev)
          local function map(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
          map("gD", function() Snacks.picker.lsp_declarations() end, "Go to declaration")
          map("gr", function() Snacks.picker.lsp_references() end, "References")
          map("gI", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")
          map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover docs")
          map("<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<F2>", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
          end, "Toggle inlay hints")
          map("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
          map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
          map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
        end,
      })
    end,
  },

  -- Formatters and debug adapters that aren't language servers
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "prettierd", "stylua", "clang-format", "google-java-format", "debugpy", "codelldb" },
    },
  },
}
