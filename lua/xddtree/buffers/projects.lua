local Data = require("xddtree.data")

local Projects = {}

function Projects.new()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  return setmetatable({ bufnr = bufnr }, { __index = Projects })
end

function Projects:update()
  local data = Data.get() or {}
  local lines = {}
  for project in pairs(data) do
    table.insert(lines, project)
  end
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
end

return Projects
