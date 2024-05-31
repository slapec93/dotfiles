local autocmd = vim.api.nvim_create_autocmd

autocmd("VimResized", { pattern = "*", command = ":wincmd =" })
autocmd("BufNewFile,BufRead", { pattern = "*.json.jbuilder", command = ":set ft=ruby" })
autocmd("BufNewFile,BufRead", { pattern = "*.rbi", command = ":set ft=ruby" })

autocmd("BufWritePost", { pattern = "*.rb", command = "FormatWrite" })
autocmd("BufWritePost", { pattern = "*.tsx,*.ts,*.jsx,*.js", command = "FormatWrite" })
autocmd("BufWritePre", { pattern = "*.tsx,*.ts,*.jsx,*.js", command = "EslintFixAll" })
-- vim.cmd [[autocmd BufWritePre * Format]]
-- vim.cmd [[autocmd BufWritePost * FormatWrite]]
-- vim.cmd [[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll]]
