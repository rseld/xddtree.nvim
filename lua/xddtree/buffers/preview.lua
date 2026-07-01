local Preview = {}

Preview.__index = Preview

function Preview.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Preview })
end

function Preview:create_preview(node)
  if node.type ~= "file" then return end

  local lines = vim.fn.readfile(node.path)

  vim.api.nvim_set_option_value("modifiable", true, { buf = self.bufnr })
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = self.bufnr })
end

return Preview
