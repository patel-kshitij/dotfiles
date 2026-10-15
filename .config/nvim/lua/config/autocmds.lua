local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Flash yanked text
au("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank() end,
})

-- Reopen files at the last cursor position
au("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 2-space indent for web files and Lua
au("FileType", {
  group = group,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc", "html", "css", "scss", "yaml", "lua", "markdown" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

-- Wrap and spellcheck prose
au("FileType", {
  group = group,
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- Close helper windows with q
au("FileType", {
  group = group,
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})
