local Data = require("xddtree.data")
local Util = require("xddtree.utils")

local Projects = {}

local projectGraph = {
  project = {},
}

local function get_current_node()
  --since nvim_win_get_cursor returns val as 0 indexed we need to conv between 0 and 1 index
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  return projectGraph.project[line + 1]
end

local function build_nodes()
  local data = Data.get()
  local projects = {}

  if data then
    for project in pairs(data) do
      table.insert(projects, project)
    end
  end

  return projects
end

local function select(project, index)

end

function Projects.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Projects })
end

function Projects:update()
  local data = Data.get()
  if data then
    local lines = {}
    for project in pairs(data) do
      table.insert(lines, project)
    end
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
  end
end

return Projects
