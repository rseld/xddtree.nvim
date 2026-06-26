local Utils = {}

function Utils.working_dir()
  local root = vim.fn.system("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(root)
end

function Utils.current_file()
  return vim.api.nvim_buf_get_name(0)
end

function Utils.current_dir()
  local proj_dir = Utils.working_dir()
  if proj_dir ~= nil then
    return proj_dir
  end
end

return Utils
