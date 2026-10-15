return {
  { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
  { "echasnovski/mini.surround", event = "VeryLazy", opts = {} }, -- sa / sd / sr
  { "echasnovski/mini.ai", event = "VeryLazy", opts = {} },       -- better a/i textobjects

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Project diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols outline" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
    },
  },

  -- Jump anywhere on screen: press S, type 2 letters, then the label
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "S", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote flash" },
    },
  },

  -- Pin your main files and jump to them with Space 1-5
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { settings = { save_on_toggle = true } },
    config = function(_, opts) require("harpoon"):setup(opts) end,
    keys = function()
      local keys = {
        { "<leader>ja", function() require("harpoon"):list():add() end, desc = "Pin this file" },
        { "<leader>jj", function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end, desc = "Pinned files (edit/reorder)" },
      }
      for i = 1, 5 do
        table.insert(keys, { "<leader>" .. i, function() require("harpoon"):list():select(i) end, desc = "Pinned file " .. i })
      end
      return keys
    end,
  },
}
