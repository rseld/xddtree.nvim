local Path = require("plenary.path")
local Marks = require("xddtree.buffers.marks")

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

function Data.write_data(mark_list, proj_list)
  local marks = {}

  Path:new(data_path):write(vim.json.encode(), "w")
end

function Data.read_data()
  ensure_data_path()

  -- will eventually allow for a path to be specified or use default path
  local path = data_path
  Marks.markTable = vim.json.decode(Path:new(path):read())
end

return Data
