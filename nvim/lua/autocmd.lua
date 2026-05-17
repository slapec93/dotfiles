local autocmd = vim.api.nvim_create_autocmd

autocmd("VimResized", { pattern = "*", command = ":wincmd =" })
autocmd("BufNewFile", { pattern = "*.json.jbuilder", command = ":set ft=ruby" })
autocmd("BufRead", { pattern = "*.json.jbuilder", command = ":set ft=ruby" })
autocmd("BufNewFile", { pattern = "*.rbi", command = ":set ft=ruby" })
autocmd("BufRead", { pattern = "*.rbi", command = ":set ft=ruby" })

autocmd("FileType", { pattern = "*", callback = function() pcall(vim.treesitter.start) end })

autocmd("BufWritePost", { pattern = "*.rb", command = "FormatWrite" })
autocmd("BufWritePost", { pattern = "*.tsx,*.ts,*.jsx,*.js", command = "FormatWrite" })
autocmd("BufWritePre", { pattern = "*.tsx,*.ts,*.jsx,*.js", callback = function()
  local eslint_configs = {
    ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml",
    ".eslintrc.yml", ".eslintrc.json", "eslint.config.js",
    "eslint.config.mjs", "eslint.config.cjs",
  }
  local dir = vim.fn.expand("%:p:h")
  for _, name in ipairs(eslint_configs) do
    if vim.fn.findfile(name, dir .. ";") ~= "" then
      vim.cmd("LspEslintFixAll")
      break
    end
  end
end })
