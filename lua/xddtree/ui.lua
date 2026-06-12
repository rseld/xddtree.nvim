local UI = {}

local state = require("xddtree.state")
local marks = require("xddtree.marks")

local function open_float(buf, opts)
  return vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = opts.row,
    col = opts.col,
    width = opts.width,
    height = opts.height,
    style = "minimal",
    border = "solid",
  })
end

function UI.open(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.6)
  local height = opts.height or math.floor(vim.o.lines * 0.6)
  local row = opts.row or math.floor((vim.o.lines - height) / 2)
  local col = opts.col or math.floor((vim.o.columns - width) / 2)

  local top_h = math.floor(height / 2)
  local top_w = math.floor(width)
  local bot_h = math.floor(height - top_h)
  local bot_w = math.floor(width)

  local layout = {
    top = {
      row = row,
      col = col,
      width = top_w,
      height = top_h,
    },
    bot = {
      -- Reason for the arbitrary 3 is just to account for the padding introduced by window borders since I want a gap
      row = row + top_h + 3,
      col = col,
      width = bot_w,
      height = bot_h,
    },
  }

  state.buffers.top = marks.create_buf()
  vim.api.nvim_buf_set_lines(state.buffers.top, 0, -1, false, state.marks)
  state.buffers.bot = marks.create_buf()

  state.windows.top = open_float(state.buffers.top, layout.top)
  state.windows.bot = open_float(state.buffers.bot, layout.bot)

  state.open = true
end

function UI.close()
  for _, win in pairs(state.windows) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  state.windows = {}
  state.buffers = {}
  state.open = false
end

function UI.toggle_tree()
  if state.open == false then
    UI.open()
  else
    UI.close()
  end
end

return UI
