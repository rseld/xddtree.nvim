local Preset = require("xddtree.preset")
local Window = require("xddtree.window")
local Tree = require("xddtree.buffers.tree")
local Marks = require("xddtree.buffers.marks")
local Data = require("xddtree.data")

local M = {}

local layout = nil
local tree = nil
local marks = nil

function M.setup(opts)

end

function M.open()
  marks = Marks.new()
  tree = Tree.new()

  layout = Preset.default_split({
    Window.new({ bufnr = marks.bufnr, border = "single", title = " Marks ", win_opts = { number = true } }),
    Window.new({ border = "single", title = " Projects " }),
    Window.new({ bufnr = tree.bufnr, enter = true, border = "single", title = " Tree " }),
  })
  layout:open()
  tree:update()
  marks:update()
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

function M.save()
  Data.write_data()
end

function M.load()
  Data.read_data()
end

function M.add()
  Marks.add()
end

return M
