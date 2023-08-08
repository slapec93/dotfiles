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
set.termguicolors = true

require('plugins')
require('autocmd')
require('find_spec')
require('key_mappings')
require('colors')
require('git')
