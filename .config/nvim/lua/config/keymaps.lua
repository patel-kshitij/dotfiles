local map = vim.keymap.set

-- Window navigation (same as your old vimrc)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>")
map("n", "<C-Down>", "<cmd>resize -2<cr>")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Save / quit
map({ "n", "i", "x" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<leader>n", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Keep selection when indenting; move selected lines
map("x", "<", "<gv")
map("x", ">", ">gv")
map("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines down", silent = true })
map("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up", silent = true })

-- Toggle fold (your old <space> mapping, moved under leader)
map("n", "<leader>z", "za", { desc = "Toggle fold" })

-- Leave terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Run the current file in a terminal
local runners = {
  python = function(f) return "python3 " .. f end,
  javascript = function(f) return "node " .. f end,
  typescript = function(f) return "npx tsx " .. f end,
  java = function(f) return "java " .. f end,
  c = function(f)
    local out = vim.fn.tempname()
    return ("cc -Wall -g %s -o %s && %s"):format(f, out, out)
  end,
  sh = function(f) return "bash " .. f end,
  lua = function(f) return "nvim -l " .. f end,
}
map("n", "<leader>r", function()
  local runner = runners[vim.bo.filetype]
  if not runner then
    return vim.notify("No runner for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
  end
  vim.cmd("silent! write")
  Snacks.terminal(runner(vim.fn.shellescape(vim.fn.expand("%:p"))), {
    auto_close = false,
    cwd = vim.fn.expand("%:p:h"),
    win = { position = "bottom", height = 0.3 },
  })
end, { desc = "Run current file" })
