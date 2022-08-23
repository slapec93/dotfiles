require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'

  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-nvim-lsp'

  use 'windwp/nvim-autopairs'

  use 'lewis6991/gitsigns.nvim'

  use 'Mofiqul/vscode.nvim'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'RRethy/nvim-treesitter-endwise'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
end)

local lspconfig = require('lspconfig')

local servers = { 'solargraph' }

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

local cmp = require('cmp')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
  },
}

require("nvim-autopairs").setup {}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "ruby" },
  auto_install = true,
  highlight = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
}

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true
}

require('vscode').setup({})

local hi = vim.api.nvim_set_hl
hi(0, 'LineNr', {fg='#8a8a8a'})
hi(0, "CursorLineNr", {bg='#5f5fff', fg='#eeeeee'})
hi(0, 'SpecialKey', {fg='#585858'})
hi(0, 'SignColumn', {bg='#000000'})
hi(0, 'GitSignsAdd', {bg='#008700', fg='#ffffff'})
hi(0, 'GitSignsChange', {bg='#0000ff', fg='#080808'})
hi(0, 'GitSignsDelete', {bg='#ff0000', fg='#080808'})
hi(0, 'GitSignsChangeDelete', {bg='#ff0000', fg='#080808'})

require('lualine').setup({
    options = {
      theme = 'vscode',
      powerline_fonts = true
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  })

local map = vim.api.nvim_set_keymap
map('n', '<c-p>', ":lua require('telescope.builtin').find_files()<cr>", {noremap = true})
map('n', '<leader>f', ":lua require('telescope.builtin').live_grep()<cr>", {noremap = true})
map('n', '<leader>ff', ":lua require('telescope.builtin').grep_string()<cr>", {noremap = true})
