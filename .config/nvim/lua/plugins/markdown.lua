-- Preview the current markdown file with glow in a floating terminal
local function glow()
  local file = vim.fn.expand("%:p")
  if vim.bo.modified then vim.cmd("silent write") end
  Snacks.terminal({ "glow", "-p", "-w", tostring(math.floor(vim.o.columns * 0.8) - 4), file }, {
    interactive = true,
    win = { position = "float", width = 0.85, height = 0.9, border = "rounded", title = " glow " },
  })
end

vim.api.nvim_create_user_command("Glow", glow, { desc = "Preview markdown with glow" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>mp", glow, { buffer = ev.buf, desc = "Preview with glow" })
  end,
})

return {}
