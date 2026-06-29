local Util = require("xddtree.utils")
local Data = require("xddtree.data")

local Marks = {}

function Marks.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Marks })
end

local function is_marked(path, cwd)
  local data = Data.projects
  for _, p in ipairs(data[cwd]) do
    if p == path then
      return true
    end
  end
  return false
end

function Marks.add(path)
  local data = Data.projects
  local cwd = Util.working_dir()
  path = path or Util.current_file()
  if not cwd then
    return vim.print("Not in a project repo")
  end
  if not data[cwd] then
    return vim.print("No marked project directory for file")
  end
  if is_marked(path, cwd) then
    return vim.print("File already marked")
  end
  if data[cwd] then
    table.insert(data[cwd], path)
  end
end

function Marks.remove(path)
  local data = Data.projects
  local cwd = Util.working_dir()
  path = path or Util.current_file()
  for i, p in ipairs(data[cwd]) do
    if p == path then
      table.remove(data[cwd], i)
      return
    end
  end
end

function Marks.jump(index)
  local data = Data.projects
  local cwd = Util.working_dir()
  local mark = data[cwd][index]
  if not mark then
    return
  end
  vim.cmd("edit" .. mark)
end

function Marks:update()
  local data = Data.projects
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
