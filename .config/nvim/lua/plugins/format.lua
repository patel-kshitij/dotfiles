return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "x" }, desc = "Format" },
      { "<leader>cF", function()
          vim.g.autoformat = vim.g.autoformat == false
          vim.notify("Format on save: " .. (vim.g.autoformat and "on" or "off"))
        end, desc = "Toggle format on save" },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        java = { "google-java-format" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function()
        if vim.g.autoformat == false then return end
        return { timeout_ms = 1500 }
      end,
    },
  },
}
