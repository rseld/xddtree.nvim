local Marks = {}

local state = require("xddtree.state")

function Marks.create_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  return buf
end

local function current_file()
  return vim.api.nvim_buf_get_name(0)
end

local function is_marked(path)
  path = path or current_file()
  for _, p in ipairs(state.marks) do
    if p == path then
      return true
    end
  end
  return false
end

function Marks.add(path)
  path = path or current_file()
  if path == "" then
    return
  end
  if is_marked(path) then
    return
  end
  table.insert(state.marks, path)
end

function Marks.remove(path)
  path = path or current_file()
  for i, p in ipairs(state.marks) do
    if p == path then
      table.remove(state.marks, i)
      return
    end
  end
end

function Marks.jump(index)
  local mark = state.marks[index]
  if not mark then
    return
  end
  vim.cmd("edit" .. mark)
end

return Marks
