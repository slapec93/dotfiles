vim.g.mapleader = ' '

local map = vim.api.nvim_set_keymap

map('n', '<leader>s', ':w<cr>', { noremap = true })
map('', '<leader>q', ':qa<cr>', { noremap = true })
map('', '<leader>c', ':q<cr>', { noremap = true })
map('', '<leader>qq', ':q!<cr>', { noremap = true })
map('n', '<leader>e', ':Explore<cr>', { noremap = true })
map('n', '<leader>j', '<C-w>j', { noremap = true })
map('n', '<leader>k', '<C-w>k', { noremap = true })
map('n', '<leader>h', '<C-w>h', { noremap = true })
map('n', '<leader>l', '<C-w>l', { noremap = true })
map('n', '<leader>\\', ':vsplit<cr>', { noremap = true })
map('n', '<leader>p', '"+p', { noremap = true })
map('n', '<leader>pw', 'vawp', { noremap = true })
map('v', '<leader>y', '"+y', { noremap = true })
map('n', '<leader>y', '"+yy', { noremap = true })
map('n', '<cr><cr>', 'o<esc>', { noremap = true })
map('n', '<esc>', ':noh<cr>', { noremap = true })
map('n', '<leader>bd', ':%bd|e#<cr>', { noremap = true })
-- map('n', 'gd', ':vsplit | lua vim.lsp.buf.definition()<CR>', { noremap = true })
map('n', 'gd', ":lua require('telescope.builtin').lsp_definitions({ jump_type = 'never' })<cr>", { noremap = true })

-- Line moving and duplication
map('n', '∆', ':m .+1<cr>==', { noremap = true }) -- Opttion + j
map('n', '˚', ':m .-2<cr>==', { noremap = true }) -- Opttion + k
map('n', 'Ô', ':t . <cr>==', { noremap = true }) -- Shift + Opttion + j

map('n', '<c-p>', ":lua require('telescope.builtin').find_files()<CR>", { noremap = true })
map('n', '<leader>f', ":lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
map('n', '<leader>ff', ":lua require('telescope.builtin').grep_string()<cr>", { noremap = true })
map('n', '<leader>n', ":lua require('telescope.builtin').resume()<cr>", { noremap = true })
map('n', '<leader>d', ":lua require('telescope.builtin').diagnostics()<cr>", { noremap = true })
map('n', '<leader>b', ":lua require('telescope.builtin').buffers()<cr>", { noremap = true })

map('n', '<leader>r', ":TestNearest<cr>", { noremap = true })
map('n', '<leader>rf', ":TestFile<cr>", { noremap = true })
map('n', '<leader>rl', ":TestLast<cr>", { noremap = true })

map('n', '<leader>g', ":lua require('neogit').open()<cr>", { noremap = true })
map('n', '<leader>gb', ":lua require('gitsigns').toggle_current_line_blame()<cr>", { noremap = true })

map('n', '<leader>t', ":lua open_spec_file()<cr>", { noremap = true })
map('n', '<leader>i', ":lua open_implementation_file()<cr>", { noremap = true })

map('n', '<leader>/', ":CommentToggle<cr>", { noremap = true })
map('v', '<leader>/', ":'<,'>CommentToggle<cr>", { noremap = true })

vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpRewrite<cr>", { noremap = true })
vim.keymap.set({ "n" }, "gd", ":lua require('telescope.builtin').lsp_definitions({ jump_type = 'never' })<cr>",
  { noremap = true })
