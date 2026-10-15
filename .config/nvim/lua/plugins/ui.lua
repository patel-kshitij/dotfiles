return {
  {
    "tahayvr/matteblack.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("matteblack")
      -- softer background for the "other uses of this word" highlight
      for _, g in ipairs({ "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }) do
        vim.api.nvim_set_hl(0, g, { bg = "#333333" })
      end
      -- clear backgrounds so iTerm's transparency + blur shows through
      for _, g in ipairs({
        "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn",
        "EndOfBuffer", "LineNr", "CursorLineNr", "FoldColumn", "StatusLine", "StatusLineNC",
        "SnacksNormal", "SnacksNormalNC", "SnacksPicker", "SnacksPickerBorder",
      }) do
        local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
        hl.bg = nil
        vim.api.nvim_set_hl(0, g, hl)
      end
      -- orange window borders (splits + floating windows)
      for _, g in ipairs({ "WinSeparator", "FloatBorder", "SnacksPickerBorder", "SnacksPickerInputBorder" }) do
        vim.api.nvim_set_hl(0, g, { fg = "#F59E0B" })
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      -- matteblack theme, but transparent outside the colored mode block
      local theme = vim.deepcopy(require("lualine.themes.matteblack"))
      for mode, sections in pairs(theme) do
        for name, hl in pairs(sections) do
          if name ~= "a" or mode == "inactive" then hl.bg = "NONE" end
        end
      end
      return {
        options = { theme = theme, globalstatus = true },
        sections = {
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            { function() -- active language servers
                local names = vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))
                return #names > 0 and (" " .. table.concat(names, ",")) or ""
              end },
            "filetype",
          },
        },
      }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        close_command = function(n) Snacks.bufdelete(n) end,
        offsets = { { filetype = "snacks_layout_box", text = "Explorer" } },
      },
      -- transparent tab bar: drop every background bufferline would set
      highlights = function(defaults)
        local hls = vim.deepcopy(defaults.highlights)
        for _, hl in pairs(hls) do
          if hl.bg then hl.bg = "NONE" end
        end
        return hls
      end,
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>a", group = "ai (claude)" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunk" },
        { "<leader>j", group = "pinned files" },
        { "<leader>m", group = "markdown" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },

  -- Pickers, file explorer, terminal, lazygit, notifications, dashboard
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true, sources = { explorer = { hidden = true } } },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true }, -- smooth scrolling
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true }, -- highlight other uses of the word under the cursor
    },
    keys = {
      -- find
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find files (smart)" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep project" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep project" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor", mode = { "n", "x" } },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find config file" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
      -- search
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "TODOs" },
      -- explorer
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
      -- git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "x" } },
      -- buffers
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
      -- terminal (Ctrl-/ ; iTerm sends it as Ctrl-_)
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
      { "<C-_>", function() Snacks.terminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
      -- misc
      { "<leader>sn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
    },
  },
}
