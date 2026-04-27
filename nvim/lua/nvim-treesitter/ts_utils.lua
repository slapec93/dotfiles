-- Compatibility shim: ts_utils was removed from nvim-treesitter.
-- nvim-test still requires it, so we provide the subset it needs.
local M = {}

M.get_node_at_cursor = function()
  return vim.treesitter.get_node()
end

return M
