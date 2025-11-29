---@brief
---
--- https://github.com/automattic/harper
---
--- The language server for Harper, the slim, clean language checker for developers.
---
--- See our [documentation](https://writewithharper.com/docs/integrations/neovim) for more information on settings.
---
--- In short, they should look something like this:
--- This is very c
--- ```lua
--- vim.lsp.config('harper_ls', {
---   settings = {
---     ["harper-ls"] = {
---       userDictPath = "~/dict.txt"
---     }
---   },
--- })
--- ```
return {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = {
    'c',
    'cpp',
    'cs',
    'gitcommit',
    'go',
    'html',
    'java',
    'javascript',
    'lua',
    'markdown',
    'nix',
    'python',
    'ruby',
    'rust',
    'swift',
    'toml',
    'typescript',
    'typescriptreact',
    'haskell',
    'cmake',
    'typst',
    'php',
    'dart',
    'clojure',
  },
  root_markers = { '.git' },
  settings = {
    ['harper-ls'] = {
      userDictPath = "~/.local/share/harper/dict.txt",
      isolateEnglish = false, -- Does not seem to work as well as I hoped
      isLikelyEnglish = false, -- Does not seem to work as well as I hoped
      linters = {
        SpellCheck = true,
        SentenceCapitalization = true,
        SpelledNumbers = false,
        ToDoHyphen = false,
      },
      markdown = {
        IgnoreLinkTitle = true,
      },
    },
  }
}
