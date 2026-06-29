local Util = require("xddtree.utils")
local Data = require("xddtree.data")

local Projects = {}

function Projects.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Projects })
end

function Projects.add()
  local data = Data.projects
  local cwd = Util.working_dir()
  if cwd == "" then
    return
  end
  if not data[cwd] then
    data[cwd] = {}
  end
end

function Projects.remove(cwd)
  local data = Data.projects
  cwd = cwd or Util.current_dir()
  for i, p in ipairs(data) do
    if p == cwd then
      table.remove(data, i)
      return
    end
  end
end

function Projects:update()
  local data = Data.projects
  local lines = {}
  for project, _ in pairs(data) do
    table.insert(lines, project)
  end
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
end

return Projects
