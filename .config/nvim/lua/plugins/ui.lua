return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "auto", globalstatus = true },
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
    },
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
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunk" },
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
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true },
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
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
    },
  },
}
