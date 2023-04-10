-- mapping_rules = {
--   "app/controllers"="spec/requests",
--   "app/lib"="spec/integration"
-- }

function open_spec_file()
  local specfile = vim.fn.expand("%"):gsub("app/", "spec/"):gsub(".rb", "_spec.rb")
  if not file_exists(specfile) then
    specfile = vim.fn.expand("%"):gsub("app/controllers", "spec/requests"):gsub(".rb", "_spec.rb")
  end
  if not file_exists(specfile) then
    specfile = vim.fn.expand("%"):gsub("app/lib", "spec/integration"):gsub(".rb", "_spec.rb")
  end
  if not file_exists(specfile) then
    specfile = vim.fn.expand("%"):gsub("app/lib/backfills/scripts", "spec/backfills"):gsub(".rb", "_spec.rb")
  end
  vim.api.nvim_command("only")
  vim.api.nvim_command("vsplit +edit " .. specfile)
end

function open_implementation_file()
  local implfile = vim.fn.expand("%"):gsub("spec/", "app/"):gsub("_spec.rb", ".rb")
  if not file_exists(implfile) then
    implfile = vim.fn.expand("%"):gsub("spec/requests", "app/controllers"):gsub("_spec.rb", ".rb")
  end
  if not file_exists(implfile) then
    implfile = vim.fn.expand("%"):gsub("spec/integration", "app/lib"):gsub("_spec.rb", ".rb")
  end
  if not file_exists(specfile) then
    specfile = vim.fn.expand("%"):gsub("spec/backfills", "app/lib/backfills/scripts"):gsub("_spec.rb", ".rb")
  end
  vim.api.nvim_command("only")
  vim.api.nvim_command("vsplit +edit " .. implfile)
end


function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  end
  return false
end
