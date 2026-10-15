return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- Tab/S-Tab to move, Enter to accept, C-space to open, C-e to close
      keymap = { preset = "super-tab", ["<CR>"] = { "accept", "fallback" } },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
        menu = { border = "rounded" },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
