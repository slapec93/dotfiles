vim.g.mapleader = ' '

local map = vim.api.nvim_set_keymap

map('n', '<leader>b', ':luafile ~/.config/nvim/init.lua<cr>', {})
map('n', '<leader>s', ':w<cr>', {noremap = true})
map('', '<leader>q', ':q<cr>', {noremap = true})
map('n', '<leader>e', ':Explore<cr>', {noremap = true})
map('n', '<leader>j', '<C-w>j', {noremap = true})
map('n', '<leader>k', '<C-w>k', {noremap = true})
map('n', '<leader>h', '<C-w>h', {noremap = true})
map('n', '<leader>l', '<C-w>l', {noremap = true})
map('n', '<leader>\\', ':vsplit<cr>', {noremap = true})
map('n', '<leader>p', '"+p', {noremap = true})
map('v', '<leader>y', '"+y', {noremap = true})
map('n', '<leader>y', '"+yy', {noremap = true})

-- Line moving and duplication
map('n', '∆', ':m .+1<cr>==', {noremap = true}) -- Opttion + j
map('n', '˚', ':m .-2<cr>==', {noremap = true}) -- Opttion + k
map('n', '˚', ':t . <cr>==', {noremap = true}) -- Shift + Opttion + j

local set = vim.opt

set.encoding = 'utf-8'
set.cursorline = true
set.modelines = 0
set.modeline = false
set.ignorecase = true
set.smartcase = true
set.smarttab = true
set.mouse = 'a'
set.list = true
set.listchars = 'tab:>-,trail:·,nbsp:·,space:·'
set.autoread = true
set.re = 1
set.updatetime = 100
set.autowrite = true

set.splitright = true

set.incsearch = true
set.hlsearch = true

set.shortmess:remove('S')

set.relativenumber = true
set.nu = true
set.rnu = true

require('plugins')
