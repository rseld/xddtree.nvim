local Preset = require("xddtree.preset")
local Window = require("xddtree.window")

local M = {}

local layout = nil

function M.setup(opts)

end

function M.open()
  layout = Preset.default_split({
    Window.new({ border = "single", title = " Marks ", win_opts = { number = true } }),
    Window.new({ border = "single", title = " Projects " }),
    Window.new({ enter = true, border = "single", title = " Tree " }),
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
