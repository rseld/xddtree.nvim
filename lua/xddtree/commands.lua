local Commands = {}

local ui = require("xddtree.ui")
local marks = require("xddtree.marks")
local data = require("xddtree.data")
local state = require("xddtree.state")

vim.keymap.set("n", "<leader>tt", ui.toggle_tree, {})
vim.keymap.set("n", "<leader>ma", marks.add, {})
vim.keymap.set("n", "<leader>mr", marks.remove, {})
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    marks.jump(i)
  end)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    data.write_data(state.marks)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    data.read_data()
  end
})
return Commands
