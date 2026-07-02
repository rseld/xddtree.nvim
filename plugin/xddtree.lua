local xddtree = require("xddtree")

vim.api.nvim_create_user_command("OpenLayout", xddtree.open, {})
vim.api.nvim_create_user_command("CloseLayout", xddtree.close, {})
vim.api.nvim_create_user_command("ToggleLayout", xddtree.toggle_layout, {})

vim.api.nvim_create_user_command("SaveMarks", xddtree.save, {})
vim.api.nvim_create_user_command("LoadMarks", xddtree.load, {})

vim.api.nvim_create_user_command("AddMark", xddtree.addmark, {})
vim.api.nvim_create_user_command("AddProj", xddtree.addproj, {})

vim.api.nvim_create_user_command("ShowProj", xddtree.proj_dirs, {})

vim.keymap.set("n", "<leader>tl", xddtree.toggle_layout, {})
vim.keymap.set("n", "<leader>cd", xddtree.toggle_proj, {})

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    xddtree.jump(i)
  end)
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    xddtree.load()
  end
})

vim.api.nvim_create_user_command("PrintWD", xddtree.pwd, {})
