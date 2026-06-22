local xddtree = require("xddtree")

vim.api.nvim_create_user_command("OpenLayout", xddtree.open, {})
vim.api.nvim_create_user_command("CloseLayout", xddtree.close, {})
