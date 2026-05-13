local function find_godot_project_root()
  local cwd = vim.fn.getcwd()
  local search_paths = { '', '/..' }

  for _, path in ipairs(search_paths) do
    local project_file = cwd .. path .. '/project.godot'
    if vim.uv.fs_stat(project_file) then
      return cwd .. path
    end
  end
end

local function is_server_running(project_path)
  local server_pipe = project_path .. '/server.pipe'
  return vim.uv.fs_stat(server_pipe) ~= nil
end

local function start_godot_server_if_needed()
  local root = find_godot_project_root()

  if root and not is_server_running(root) then
      vim.fn.serverstart(root .. "/server.pipe")
  end
end

start_godot_server_if_needed()
