require('gitsigns').setup {
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '-' },
    topdelete    = { text = '-' },
    changedelete = { text = '~' },
  },
  signcolumn = true
}

require('git-conflict').setup()

require('neogit').setup {
  integrations = {
    diffview = true
  }
}
