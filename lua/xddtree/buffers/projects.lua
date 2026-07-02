local Data = require("xddtree.data")

local Projects = {}
Projects.__index = Projects

Projects.projectGraph = {
  project = {},
}

function Projects.get_current_node()
  --since nvim_win_get_cursor returns val as 0 indexed we need to conv between 0 and 1 index
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  return Projects.projectGraph.project[line + 1]
end

local function build_nodes()
  local data = Data.get()

  if data then
    for project in pairs(data) do
      table.insert(Projects.projectGraph.project, project)
    end
  end
end

function Projects.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  build_nodes()
  return setmetatable({ bufnr = bufnr }, Projects)
end

function Projects:update(data)
  if data then
    local lines = {}
    for project in pairs(data) do
      table.insert(lines, project)
    end
    vim.api.nvim_set_option_value("modifiable", true, { buf = self.bufnr })
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = self.bufnr })
  end
end

function Projects:close()
  Projects.projectGraph.project = {}
end

-- Note: I have telescope look in global working dir for files which is what motivates setting global
function Projects:set_cwd(node)
  if not node then
    return vim.print("Invalid project directory")
  end
  vim.api.nvim_set_current_dir(node)
  vim.cmd("verbose pwd")
end

return Projects
