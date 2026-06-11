local UI = {}
local State = require("state")

local function create_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  return buf
end

local function open_float(buf, opts)
  return vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = opts.row,
    col = opts.col,
    width = opts.width,
    height = opts.height,
    style = "minimal",
    border = "single",
  })
end

function UI.open(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local top_h = height / 2
  local top_w = width
  local bot_h = height - top_h
  local bot_w = width

  local layout = {
    top = {
      row = 0,
      col = 0,
      width = top_w,
      height = top_h,
    },
    bot = {
      row = top_h,
      col = 0,
      width = bot_w,
      height = bot_h,
    },
  }

  State.buffers.top = create_buf()
  State.buffers.bot = create_buf()

  State.windows.top = open_float(State.buffers.top, layout.top)
  State.windows.bot = open_float(State.buffers.bot, layout.bot)

  State.open = true
end

function UI.close()
  for _, win in pairs(State.windows) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  State.windows = {}
  State.buffers = {}
  State.open = false
end

return UI
