local Window = {}
Window.__index = Window

function Window.new(opts)
  return setmetatable({
    row = opts.row,
    col = opts.col,
    width = opts.width,
    height = opts.height,
    enter = opts.enter or false,
    title = opts.title or "",
    border = opts.border or "none",
    win_opts = opts.win_opts or {},
    bufnr = opts.bufnr or nil,
    winnr = nil,
    layout = nil,
  }, Window)
end

function Window:open(enter)
  self.external_buf = self.bufnr ~= nil
  if not self.bufnr then
    self.bufnr = vim.api.nvim_create_buf(false, true)
  end
  self.winnr = vim.api.nvim_open_win(self.bufnr, enter or false, {
    relative = "editor",
    row = self.row,
    col = self.col,
    width = self.width,
    height = self.height,
    style = "minimal",
    title = self.title,
    border = self.border,
  })
  for opt, val in pairs(self.win_opts) do
    vim.api.nvim_set_option_value(opt, val, { win = self.winnr })
  end
end

function Window:close()
  if self.winnr then
    vim.api.nvim_win_close(self.winnr, true)
    self.winnr = nil
  end
  if self.bufnr and not self.external_buf then
    vim.api.nvim_buf_delete(self.bufnr, { force = true })
    self.bufnr = nil
  end
end

function Window:border_offset()
  if not self.border or self.border == "none" then
    return 0
  end
  return 1
end

return Window
