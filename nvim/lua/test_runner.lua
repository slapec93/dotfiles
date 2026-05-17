local M = {}

-- Scan upward from cursor to find the enclosing it() and describe() blocks
-- Uses brace counting to skip over sibling blocks
local function get_test_context()
  local cursor_line = vim.fn.line('.')
  local lines = vim.api.nvim_buf_get_lines(0, 0, cursor_line, false)

  local it_name = nil
  local describe_names = {}
  local depth = 0

  for i = cursor_line, 1, -1 do
    local line = lines[i]

    local _, closes = line:gsub('[}%)]', '')
    local _, opens = line:gsub('[{%(]', '')

    depth = depth + closes

    -- A line is an ancestor only if its opens exceed the accumulated depth,
    -- meaning it has an unmatched opening brace that contains the cursor
    if opens > depth then
      if not it_name then
        local it_match = line:match("^%s*it%s*%(['\"](.+)['\"]")
        if it_match then
          it_name = it_match
        end
      end

      local desc_match = line:match("describe%w*%s*%(['\"](.+)['\"]")
      if desc_match then
        table.insert(describe_names, 1, desc_match)
      end

      depth = 0
    else
      depth = depth - opens
    end
  end

  local describe_name = #describe_names > 0 and table.concat(describe_names, ' ') or nil
  return it_name, describe_name
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

  vim.fn.termopen('SKIP_COVERAGE=true npx jest --verbose ' .. args)
end

function M.run_nearest()
  local file = vim.fn.expand('%')
  local it_name, describe_name = get_test_context()

  if it_name then
    run_jest(file .. ' --testNamePattern="' .. it_name .. '$"')
  elseif describe_name then
    run_jest(file .. ' --testNamePattern="' .. describe_name .. '$"')
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
