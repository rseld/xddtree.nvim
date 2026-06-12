local Commands = {}

local ui = require("xddtree.ui")
local marks = require("xddtree.marks")

vim.keymap.set("n", "<leader>tt", ui.toggle_tree, {})
vim.keymap.set("n", "<leader>ma", marks.add, {})
vim.keymap.set("n", "<leader>mr", marks.remove, {})
vim.keymap.set("n", "<leader>1", function()
  marks.jump(1)
end)
vim.keymap.set("n", "<leader>2", function()
  marks.jump(2)
end)
vim.keymap.set("n", "<leader>3", function()
  marks.jump(3)
end)
vim.keymap.set("n", "<leader>4", function()
  marks.jump(4)
end)
vim.keymap.set("n", "<leader>5", function()
  marks.jump(5)
end)

return Commands
