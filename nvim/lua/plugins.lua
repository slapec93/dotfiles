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

  use 'Mofiqul/vscode.nvim'

  use 'klen/nvim-test'

  use "lukas-reineke/lsp-format.nvim"

  use 'mhartington/formatter.nvim'

  use { 'akinsho/git-conflict.nvim', tag = "*", config = function()
    require('git-conflict').setup()
  end }

  use { 'NeogitOrg/neogit', requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' } }

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
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use 'terrortylor/nvim-comment'

  use 'lukas-reineke/indent-blankline.nvim'

  use {
    "rockyzhang24/arctic.nvim",
    requires = { "rktjmp/lush.nvim" }
  }

  use 'lewis6991/gitsigns.nvim'

  use 'folke/sidekick.nvim'
end)


require('telescope').setup {
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

local servers = { 'ruby_lsp', 'sorbet', 'ts_ls', 'eslint', 'gopls' }
local on_attach = function(client, bufnr)
  require "lsp-format".on_attach(client)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gp', ":lua require('telescope.builtin').lsp_definitions({ jump_type = 'never' })<cr>", bufopts)
  vim.keymap.set('n', 'gs', ":lua require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })<cr>", bufopts)
  vim.keymap.set('n', 'gd', ":lua require('telescope.builtin').lsp_definitions()<cr>", bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })
end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

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
  menu = 'wildmenu',
  mapping = cmp.mapping.preset.insert({
    ['<C-Tab>'] = cmp.mapping.scroll_docs(-4),
    ['<S-Tab>'] = cmp.mapping.scroll_docs(4),
    ['<C-.>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['[['] = cmp.mapping(function(fallback)
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
    [']]'] = cmp.mapping(function(fallback)
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

function ReadFile(path)
  local file = assert(io.open(path, "r"))
  local content = file:read "*a"
  file:close()
  return content
end

local ruby_query = ReadFile('/Users/gergelybekesi/.config/nvim/lua/treesitter/query/ruby/highlights.scm')
require("vim.treesitter.query").set("ruby", "highlights", ruby_query)

local parsers = require "nvim-treesitter.parsers"
local parser_config = parsers.get_parser_configs()
parser_config.html.filetype_to_parsername = "json"

vim.cmd.colorscheme "arctic"

require('lualine').setup({
  options = {
    theme = 'vscode',
    powerline_fonts = true,
    refresh = {
      statusline = 500
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { "require'lsp-status'.status()", 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
})

require('nvim-test').setup({

  termOpts = {
    direction = "float", -- terminal's direction ("horizontal"|"vertical"|"float")
    width = 96,          -- terminal's width (for vertical|float)
    height = 48,         -- terminal's height (for horizontal|float)
    go_back = false,     -- return focus to original window after executing
    stopinsert = "auto", -- exit from insert mode (true|false|"auto")
    keep_one = true,     -- keep only one terminal for testing
  },
})

require('nvim-test.runners.rspec'):setup {
  command = "./bin/rspec",
  args = { "--format=doc" },
  file_pattern = "\\v(spec_[^.]+|[^.]+_spec)\\.rb$", -- determine whether a file is a testfile
}

require('nvim_comment').setup {
  create_mappings = false
}

vim.api.nvim_set_hl(0, 'ScopeHighlight', { fg = '#00ff00' })
require('ibl').setup {
  scope = { enabled = true, highlight = 'ScopeHighlight', char = '│', show_start = false },
}
