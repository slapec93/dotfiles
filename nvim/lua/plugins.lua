require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'

  use 'arkav/lualine-lsp-progress'

  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-nvim-lsp'

  use 'L3MON4D3/LuaSnip'

  use 'saadparwaiz1/cmp_luasnip'

  use 'windwp/nvim-autopairs'

  use 'lewis6991/gitsigns.nvim'

  use 'Mofiqul/vscode.nvim'

  use 'klen/nvim-test'

  use "lukas-reineke/lsp-format.nvim"

  use 'mhartington/formatter.nvim'

  use { 'akinsho/git-conflict.nvim', tag = "*" }

  use { 'TimUntersberger/neogit', requires = {'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim'} }

  use { 'kyazdani42/nvim-web-devicons' }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'RRethy/nvim-treesitter-endwise'

  use 'windwp/nvim-ts-autotag'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'terrortylor/nvim-comment'

  use 'lukas-reineke/indent-blankline.nvim'
end)

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["∂"] = require('telescope.actions').delete_buffer -- Option key + D
      }
    }
  },
  pickers = {
    find_files = {
      find_command = {
        'fd',
        '-HI',
        '-t', 'file',
        '-E', '.git',
        '-E', 'node_modules',
        '-E', 'tmp'
      }
    }
  }
}

require('lsp-format').setup {}

local lspconfig = require('lspconfig')

local servers = { 'solargraph', 'tsserver', 'eslint' }

local on_attach = function(client, bufnr)
  require "lsp-format".on_attach(client)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local luasnip = require 'luasnip'
luasnip.filetype_extend("ruby", { "rspec" })
require("luasnip.loaders.from_snipmate").lazy_load()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-.>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }),
}
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

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
  autotag = {
    enable = true,
  }
}

require('vscode').setup({})

local lsp_progress = {'lsp_progress', timer = { progress_enddelay = 500, spinner = 500, lsp_client_name_enddelay = 500 }, spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' }}

require('lualine').setup({
    options = {
      theme = 'vscode',
      powerline_fonts = true,
      refresh = {
        statusline = 500
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {{'filename', path = 1}},
      lualine_x = {lsp_progress, 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  })

require('nvim-test').setup({
  termOpts = {
    direction = "float",      -- terminal's direction ("horizontal"|"vertical"|"float")
    width = 96,               -- terminal's width (for vertical|float)
    height = 48,              -- terminal's height (for horizontal|float)
    go_back = false,          -- return focus to original window after executing
    stopinsert = "auto",      -- exit from insert mode (true|false|"auto")
    keep_one = true,          -- keep only one terminal for testing
  },
})

function open_spec_file()
  local specfile = vim.fn.expand("%"):gsub("app/", "spec/"):gsub(".rb", "_spec.rb")
  vim.api.nvim_command("vsplit +edit " .. specfile)
end

require('nvim-test.runners.rspec'):setup {
  command = "./bin/rspec",
  args = { "--format=doc" },
  file_pattern = "\\v(spec_[^.]+|[^.]+_spec)\\.rb$",   -- determine whether a file is a testfile
}

require('nvim_comment').setup {
  create_mappings = false
}

require('indent_blankline').setup {
  show_current_context = true,
  show_current_context_start = true,
}

require('git-conflict').setup()
--[[require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  filetype = {
    ruby = {
      require("formatter.filetypes.ruby").rubocop
    },
    typescript = {
      require("formatter.filetypes.typescript").prettiereslint
    },
    typescriptreact = {
      require("formatter.filetypes.typescriptreact").prettiereslint
    },
  }
}]]--
