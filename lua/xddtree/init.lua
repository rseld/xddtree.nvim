local Preset = require("xddtree.preset")
local Window = require("xddtree.window")
local Tree = require("xddtree.buffers.tree")
local Marks = require("xddtree.buffers.marks")
local Data = require("xddtree.data")
local Projects = require("xddtree.buffers.projects")

local M = {}

local layout = nil
local tree = nil
local marks = nil
local projects = nil

function M.setup(opts)

end

function M.open()
  marks = Marks.new()
  tree = Tree.new()
  projects = Projects.new()

  layout = Preset.default_split({
    Window.new({ bufnr = marks.bufnr, border = "single", title = " Marks ", win_opts = { number = true } }),
    Window.new({ bufnr = projects.bufnr, border = "single", title = " Projects ", win_opts = { number = true } }),
    Window.new({ bufnr = tree.bufnr, enter = true, border = "single", title = " Tree " }),
  })
  layout:open()
  tree:update()
  marks:update()
  projects:update()
end

function M.close()
  if layout then
    layout:close()
    layout = nil
  end
  if tree then
    tree:close()
  end
end

function M.toggle()
  if not layout then
    M.open()
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

return M
