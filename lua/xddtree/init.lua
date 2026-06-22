local Preset = require("xddtree.preset")
local Window = require("xddtree.window")

local M = {}

local layout = nil

function M.setup(opts)

end

function M.open()
  layout = Preset.default_split({
    Window.new({ border = "single", title = "TL" }),
    Window.new({ border = "single", title = "BL" }),
    Window.new({ border = "single", title = "R" }),
  })
  layout:open()
end

function M.close()
  if layout then
    layout:close()
    layout = nil
  end
end

return M
