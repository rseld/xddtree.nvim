local Utils = require("xddtree.utils")
local Preview = require("xddtree.buffers.preview")

local Tree = {}

Tree.treeGraph = {
  root = nil,
  nodes = {},
}

function Tree.get_current_node()
  --since nvim_win_get_cursor returns val as 0 indexed we need to conv between 0 and 1 index
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  return Tree.treeGraph.nodes[line + 1]
end

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

    table.insert(Tree.treeGraph.nodes, node)
  end
end

local function render_tree()
  local prefixes = {
    directory = "+ ",
    file = "  ",
  }
  local lines = {}
  for _, node in ipairs(Tree.treeGraph.nodes) do
    local prefix = prefixes[node.type] or "? "
    if node.type == "directory" and node.is_open then
      prefix = "- "
    end
    local indent = string.rep("  ", node.depth)
    local line = indent .. prefix .. node.name
    table.insert(lines, line)
  end

  return lines
end

local function expand_node(node, index)
  local children = scan_dir(node.path)

  for i, child in ipairs(children) do
    local child_node = {
      name = child.name,
      path = node.path .. "/" .. child.name,
      type = child.type,
      depth = node.depth + 1,
      is_open = false,
    }
    table.insert(Tree.treeGraph.nodes, index + i, child_node)
  end
  node.is_open = true
end

local function collapse_node(node, index)
  while Tree.treeGraph.nodes[index + 1] and Tree.treeGraph.nodes[index + 1].depth > node.depth do
    table.remove(Tree.treeGraph.nodes, index + 1)
  end
  node.is_open = false
end

function Tree:toggle_node(node, index)
  if node.type ~= "directory" then return end

  if node.is_open then
    collapse_node(node, index)
  else
    expand_node(node, index)
  end
end

function Tree.new(root)
  Tree.treeGraph.root = root
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].bufhidden = "wipe"
  build_nodes(Tree.treeGraph.root, 0)

  return setmetatable({ bufnr = bufnr }, { __index = Tree })
end

function Tree:update()
  if not Tree.treeGraph.nodes then
    build_nodes(Tree.treeGraph.root, 0)
  end
  local lines = render_tree()
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)
end

-- TODO: don't throw away treeGraph if cwd has not changed
function Tree:close()
  Tree.treeGraph.nodes = {}
end

return Tree
