local M = {}

local function get_test_name()
  local line = vim.fn.getline('.')
  return line:match("['\"](.+)['\"]")
end

local function run_jest(args)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  })

  vim.fn.termopen('npx jest --verbose ' .. args)
end

function M.run_nearest()
  local file = vim.fn.expand('%')
  local test_name = get_test_name()
  if test_name then
    run_jest(file .. ' --testNamePattern="' .. test_name .. '"')
  else
    run_jest(file)
  end
end

function M.run_file()
  local file = vim.fn.expand('%')
  run_jest(file)
end

function M.run_all()
  run_jest('')
end

return M
