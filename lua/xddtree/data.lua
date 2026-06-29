local Path = require("plenary.path")

local ensured_data_path = false
local data_path = string.format("%s/marks.json", vim.fn.stdpath("data"))

local function ensure_data_path()
  if ensured_data_path then
    return
  end

  local path = Path:new(data_path)
  if path:exists() then
    path:mkdir()
  end
  ensured_data_path = true
end

local Data = {}

Data.projects = {}

function Data.write_data()
  Path:new(data_path):write(vim.json.encode(Data.projects), "w")
end

function Data.read_data()
  ensure_data_path()
  -- will eventually allow for a path to be specified or use default path
  Data.projects = vim.json.decode(Path:new(data_path):read())
end

return Data
