local Preset   = require("xddtree.preset")
local Window   = require("xddtree.window")
local Tree     = require("xddtree.buffers.tree")
local Marks    = require("xddtree.buffers.marks")
local Data     = require("xddtree.data")
local Projects = require("xddtree.buffers.projects")
local Preview  = require("xddtree.buffers.preview")
local Utils    = require("xddtree.utils")

local M        = {}

local layout   = nil

function M.setup(opts)

end

function M.open()
  local cwd = Utils.working_dir()

  local mark = Marks.new()
  local tree = Tree.new(cwd)
  local preview = Preview.new()

  vim.keymap.set("n", "<CR>", function()
    local node = Tree.get_current_node()
    local index = vim.api.nvim_win_get_cursor(0)[1]
    tree:toggle_node(node, index)
    tree:update()
  end, { buffer = tree.bufnr })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = tree.bufnr,
    callback = function()
      local node = Tree.get_current_node()
      preview:create_preview(node)
    end
  })

  layout = Preset.mark_layout({
    Window.new({ bufnr = mark.bufnr, border = "single", title = " Marks ", win_opts = { number = true } }),
    Window.new({ bufnr = tree.bufnr, enter = true, border = "single", title = " Tree " }),
    Window.new({ bufnr = preview.bufnr, border = "single", title = " Preview " }),
  })
  layout:open()
  mark:update()
  tree:update()
end

function M.proj_dirs()
  local projects = Projects.new()

  vim.keymap.set("n", "<CR>", function()
    local node = Projects.get_current_node()
    projects:set_cwd(node)
  end, { buffer = projects.bufnr })

  layout = Preset.project_dirs({
    Window.new({ bufnr = projects.bufnr, enter = true, border = "single", title = " Projects ", win_opts = { number = true } }),
  })
  layout:open()
  projects:update()
end

function M.close()
  if layout then
    layout:close()
    layout = nil
    Tree:close()
  end
end

function M.toggle_layout()
  if not layout then
    M.open()
  else
    M.close()
  end
end

function M.toggle_proj()
  if not layout then
    M.proj_dirs()
  else
    M.close()
  end
end

function M.save()
  Data.write_data()
end

function M.load()
  Data.read_data()
end

function M.addmark()
  Data.add_mark()
end

function M.addproj()
  Data.add_project()
end

function M.jump(index)
  Marks.jump(index)
end

function M.pwd()
  Utils.show_dirs()
end

return M
