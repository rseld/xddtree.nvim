local Window = {}
Window.__index = Window

function Window.new(opts)
  return setmetatable({
    row = opts.row,
    col = opts.col,
    width = opts.width,
    height = opts.height,
    bufnr = nil,
    winnr = nil,
    layout = nil,
  }, Window)
end

function Window:open(enter)
  self.bufnr = vim.api.nvim_create_buf(false, true)
  self.winnr = vim.api.nvim_open_win(self.bufnr, enter or false, {
    relative = "editor",
    row = self.row,
    col = self.col,
    width = self.width,
    height = self.height,
    style = "minimal",
  })
end

function Window:close()
  if self.winnr then
    vim.api.nvim_win_close(self.winnr, true)
    self.winnr = nil
  end
  if self.bufnr then
    vim.api.nvim_buf_delete(self.bufnr, { force = true })
    self.bufnr = nil
  end
end

return Window
