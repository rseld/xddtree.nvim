local Preset = require("xddtree.preset")
local Window = require("xddtree.window")
local Tree = require("xddtree.buffers.tree")

local M = {}

local layout = nil
local tree = nil

function M.setup(opts)

end

function M.open()
  tree = Tree.new()

  layout = Preset.default_split({
    Window.new({ border = "single", title = " Marks ", win_opts = { number = true } }),
    Window.new({ border = "single", title = " Projects " }),
    Window.new({ bufnr = tree.bufnr, enter = true, border = "single", title = " Tree " }),
  })
  layout:open()
end

function M.close()
  if layout then
    layout:close()
    layout = nil
  end
  if tree then
    tree:close()
    tree = nil
  end
end

return M
