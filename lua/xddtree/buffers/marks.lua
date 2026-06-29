local Util = require("xddtree.utils")
local Data = require("xddtree.data")

local Marks = {}

function Marks.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Marks })
end

function Marks.jump(index)
  local cwd = Util.working_dir()
  local data = Data.get() or {}
  local mark = data[cwd][index]
  if not mark then
    return
  end
  vim.cmd("edit" .. mark)
end

function Marks:update()
  local lines = {}
  local cwd = Util.working_dir()
  local data = Data.get() or {}
  if data[cwd] then
    for _, mark in ipairs(data[cwd]) do
      table.insert(lines, mark)
    end
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  end
end

return Marks
