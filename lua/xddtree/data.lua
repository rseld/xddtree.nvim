local Path = require("plenary.path")
local Util = require("xddtree.utils")

local Data = {}

Data.projects = {}

function Data.get()
  return Data.projects
end

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

local function is_marked(path)
  local cwd = Util.working_dir()
  for _, p in ipairs(Data.projects[cwd]) do
    if p == path then
      return true
    end
  end
  return false
end

function Data.write_data()
  Path:new(data_path):write(vim.json.encode(Data.projects), "w")
end

function Data.read_data()
  ensure_data_path()
  -- will eventually allow for a path to be specified or use default path
  Data.projects = vim.json.decode(Path:new(data_path):read())
end

function Data.add_mark(path)
  local cwd = Util.working_dir()
  path = path or Util.current_file()
  if not cwd then
    return vim.print("Not in a project repo")
  end
  if not Data.projects[cwd] then
    return vim.print("No marked project directory for file")
  end
  if is_marked(path) then
    return vim.print("File already marked")
  end
  if Data.projects[cwd] then
    table.insert(Data.projects[cwd], path)
  end
  return Data.projects
end

function Data.remove_mark(path)
  local cwd = Util.working_dir()
  path = path or Util.current_file()
  for i, p in ipairs(Data.projects[cwd]) do
    if p == path then
      table.remove(Data.projects[cwd], i)
      return
    end
  end
  return Data.projects
end

function Data.add_project()
  local cwd = Util.working_dir()
  if cwd == nil then
    return
  end
  if Data.projects[cwd] == nil then
    Data.projects[cwd] = {}
  end
end

function Data.remove_project()
  local cwd = Util.working_dir()
  cwd = cwd or Util.working_dir()
  for i, p in ipairs(Data.projects) do
    if p == cwd then
      table.remove(Data.projects, i)
      return
    end
  end
  return Data.projects
end

return Data
