local Util = require("xddtree.utils")
local Data = require("xddtree.data")
local data = Data.projects

local Marks = {}

function Marks.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Marks })
end

local function is_marked(path)
  path = path or Util.current_file()
  for _, p in ipairs(Marks[cwd][path]) do
    if p == path then
      return true
    end
  end
  return false
end

function Marks.add(path)
  local cwd = Util.working_dir()
  path = path or Util.current_file()
  if not cwd then
    return vim.print("Not in a project repo")
  end
  if data[cwd] then
    table.insert(data[cwd], path)
  end
end

function Marks.remove(path)
  path = path or Util.current_file()
  for i, p in ipairs(Marks) do
    if p == path then
      table.remove(Marks[cwd][path], i)
      return
    end
  end
end

function Marks.jump(index)
  local mark = Marks.path[index]
  if not mark then
    return
  end
  vim.cmd("edit" .. mark)
end

function Marks:update()
  local cwd = Util.working_dir()
  if cwd ~= nil then
    local lines = {}
    for _, mark in ipairs(data[cwd]) do
      table.insert(lines, mark)
    end
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  end
end

return Marks
