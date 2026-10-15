return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buf, desc = desc }) end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
        map({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gt", gs.toggle_current_line_blame, "Toggle inline blame")
      end,
    },
  },
}
