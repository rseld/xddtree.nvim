local Commands = {}

local ui = require("xddtree.ui")
local marks = require("xddtree.marks")

vim.keymap.set("n", "<leader>tt", ui.toggle_tree, {})
vim.keymap.set("n", "<leader>ma", marks.add, {})
vim.keymap.set("n", "<leader>mr", marks.remove, {})

return Commands
