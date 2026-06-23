local Utils = {}

function Utils.working_dir()
  local root = vim.fn.system("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(root)
end

return Utils
