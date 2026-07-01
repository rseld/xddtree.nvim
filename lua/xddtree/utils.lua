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

return Utils
