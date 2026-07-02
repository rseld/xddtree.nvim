local Utils = {}

function Utils.working_dir()
  local cwd = vim.fn.getcwd(-1, -1)
  local root = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true, cwd = cwd }):wait()
  if root.stderr ~= '' then
    return nil
  end
  return vim.trim(root.stdout:gsub("\n", ""))
end

function Utils.current_dir()
  return vim.fn.getcwd(-1)
end

function Utils.current_file()
  return vim.api.nvim_buf_get_name(0)
end

function Utils.show_dirs()
  return vim.print({
    effective = vim.fn.getcwd(),
    global = vim.fn.getcwd(-1, -1),
    tab = vim.fn.getcwd(-1, 0),
    window = vim.fn.getcwd(0),
  })
end

return Utils
