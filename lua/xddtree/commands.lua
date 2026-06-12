local Commands = {}

local ui = require("xddtree.ui")
local marks = require("xddtree.marks")

vim.keymap.set("n", "<leader>tt", ui.toggle_tree, {})
vim.keymap.set("n", "<leader>ma", marks.add, {})
vim.keymap.set("n", "<leader>mr", marks.remove, {})
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    marks.jump(i)
  end)
end
return Commands
