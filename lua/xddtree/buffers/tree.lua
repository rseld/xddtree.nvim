local Tree = {}

local treeGraph = {
  root = nil,
  nodes = {},
}


local function scan_dir(path)
  local handle = vim.uv.fs_scandir(path)
  local entries = {}

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then break end

    table.insert(entries, { name = name, type = type })
  end

  return entries
end

local function build_nodes(path, depth)
  local entries = scan_dir(path)

  for _, entry in ipairs(entries) do
    local node = {
      name = entry.name,
      path = path .. "/" .. entry.name,
      type = entry.type,
      depth = depth,
      is_open = false,
    }

    table.insert(treeGraph.nodes, node)
  end
end

return Tree
