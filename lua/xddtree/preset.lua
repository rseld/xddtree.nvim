local Preset = {}
local Layout = require("xddtree.layout")

function Preset.default_split(windows, opts)
  local opts = opts or {}
  -- ratio of the left side ui to the right side ui
  local ratio = opts.ratio or 0.4
  -- scale of the entire set of windows
  local scale_factor = opts.scale or 0.8

  local function scale(value, factor)
    return math.floor(value * factor)
  end

  local W = scale(vim.o.columns, scale_factor)
  local H = scale(vim.o.lines, scale_factor)

  local col_offset = math.floor((vim.o.columns - W) / 2)
  local row_offset = math.floor((vim.o.lines - H) / 2)
  -- to keep vert window scaled even after lossy flooring
  local floor_height = math.floor(H / 2)

  local border = windows[1]:border_offset()

  windows[1].row = row_offset
  windows[1].col = col_offset
  windows[1].width = math.floor(W * (1 - ratio)) - border
  windows[1].height = floor_height - border

  windows[2].row = row_offset + math.floor(H / 2) + border
  windows[2].col = col_offset
  windows[2].width = math.floor(W * (1 - ratio)) - border
  windows[2].height = floor_height - border

  windows[3].row = row_offset
  windows[3].col = col_offset + math.floor(W * (1 - ratio)) + border
  windows[3].width = math.floor(W * ratio) - border
  -- remember not to subtract border gap from right window height
  -- may cause problems with alignment later
  windows[3].height = floor_height * 2

  local layout = Layout.new()
  for _, win in ipairs(windows) do
    layout:register(win)
  end
  return layout
end

return Preset
