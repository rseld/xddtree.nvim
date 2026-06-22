local Preset = {}
local Layout = require("xddtree.layout")

function Preset.default_split(windows, opts)
  local opts = opts or {}
  local ratio = opts.ratio or 0.5
  local W = vim.o.columns
  local H = vim.o.lines

  windows[1].row, windows[1].col = 0, 0
  windows[1].width, windows[1].height = W * ratio, H * 0.5

  windows[2].row, windows[2].col = H * 0.5, 0
  windows[2].width, windows[2].height = W * ratio, H * 0.5

  windows[3].row, windows[3].col = 0, W * ratio
  windows[3].width, windows[3].height = W * ratio, H

  local layout = Layout.new()
  for _, win in ipairs(windows) do
    layout:register(win)
  end
  return layout
end

return Preset
