vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function ()
    if vim.fn.getcmdtype() == "" then
      vim.cmd("checktime")
    end
  end
})
