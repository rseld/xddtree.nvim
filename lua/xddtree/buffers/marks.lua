local Marks = {}
Marks.__index = Marks

function Marks.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, Marks)
end

function Marks.jump(cwd, data, index)
  local mark = data[cwd][index]
  if not mark then
    return
  end
  vim.cmd.edit(mark)
end

function Marks:update(cwd, data)
  local lines = {}
  if data[cwd] then
    for _, mark in ipairs(data[cwd]) do
      table.insert(lines, mark)
    end
    vim.api.nvim_set_option_value("modifiable", true, { buf = self.bufnr })
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = self.bufnr })
  end
end

return Marks
