-- Claude Code inside Neovim: it sees your open file and selection, and its edits show as diffs
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = { split_side = "right", split_width_percentage = 0.4 },
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume a past chat" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last chat" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Pick model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add this file" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file from explorer", ft = { "snacks_picker_list", "netrw" } },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept change" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject change" },
    },
  },
}
