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
    win:open()
  end
  self.active = true
end

function Layout:close()
  for _, win in ipairs(self.windows) do
    win:close()
  end
  self.active = false
end

return Layout
