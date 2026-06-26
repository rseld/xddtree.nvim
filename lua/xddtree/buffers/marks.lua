local Util = require("xddtree.utils")

local Marks = {}

local markTable = {
  root = Util.working_dir(),
  path = {},
}

function Marks.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Marks })
end

local function is_marked(path)
  path = path or Util.current_file()
  for _, p in ipairs(markTable) do
    if p == path then
      return true
    end
  end
  return false
end

function Marks.add(path)
  if not markTable.root then
    return vim.print("Not in a project repo")
  end

  path = path or Util.current_file()
  if path == "" then
    return
  end
  if is_marked(path) then
    return
  end
  table.insert(markTable.path, path)
end

function Marks.remove(path)
  path = path or Util.current_file()
  for i, p in ipairs(markTable) do
    if p == path then
      table.remove(markTable, i)
      return
    end
  end
end

function Marks.jump(index)
  local mark = markTable.path[index]
  if not mark then
    return
  end
  vim.cmd("edit" .. mark)
end

function Marks:update()
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, markTable.path)
end

return Marks
