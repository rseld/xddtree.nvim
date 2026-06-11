local Commands = {}
local State = require("state")
local UI = require("ui")

local function toggle_tree()
  if State.open == false then
    UI.open()
  else
    UI.close()
  end
end

vim.keymap.set("n", "<leader>tt", toggle_tree, {})
return Commands
