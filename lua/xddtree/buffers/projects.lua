local Util = require("xddtree.utils")

local Projects = {}

local projectTable = {}

function Projects.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Projects })
end

local function current_dir()
  local proj_dir = Util.working_dir()
  if proj_dir ~= nil then
    table.insert(projectTable, proj_dir)
  end
end

local function is_listed(path)
  path = path or current_dir()
  for _, p in ipairs(projectTable) do
    if p == path then
      return true
    end
  end
  return false
end

function Projects.add(path)
  path = path or current_dir()
  if path == "" then
    return
  end
  if is_listed(path) then
    return
  end
  table.insert(projectTable, path)
end

function Projects.remove(path)
  path = path or current_dir()
  for i, p in ipairs(projectTable) do
    if p == path then
      table.remove(projectTable, i)
      return
    end
  end
end

function Projects:update()
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, projectTable)
end

return Projects
