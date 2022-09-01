function open_spec_file()
  local specfile = vim.fn.expand("%"):gsub("app/", "spec/"):gsub(".rb", "_spec.rb")
  vim.api.nvim_command("vsplit +edit " .. specfile)
end
