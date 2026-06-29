local Layout = {}
Layout.__index = Layout

function Layout.new()
  return setmetatable({
    windows = {},
    active = false,
  }, Layout)
end

function Layout:register(win)
  win.Layout = self
  table.insert(self.windows, win)
end

function Layout:open()
  for _, win in ipairs(self.windows) do
    win:open(win.enter)
  end
  self.active = true
end

function Layout:close()
  for _, win in ipairs(self.windows) do
    win:close()
  end
  self.active = false
end

function Layout:toggle_layout()
  if self.active == false then
    Layout:open()
  else
    Layout:close()
  end
end

return Layout
