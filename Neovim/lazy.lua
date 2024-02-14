local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = {
      colorscheme = "solarized-osaka",
    } },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Define the leader key
vim.g.mapleader = " "

-- Copy entire buffer contents to system clipboard
vim.api.nvim_set_keymap("n", "<Leader>c", 'ggVG"+y', { noremap = true })

-- Compile and run C++ code
vim.api.nvim_set_keymap(
  "n",
  "<Leader>r",
  ':w<CR>:! printf "Mohiittt your output is\n----------------------\n" && g++ -std=c++1z -o test %:r.cpp && ./test && printf "---------------------\n"<CR>',
  { noremap = true }
)

-- Compile and run C++ code with input from file
vim.api.nvim_set_keymap(
  "n",
  "<Leader>f",
  ':w<CR>:! printf "Mohiiiitttttt your output from file is\\n---------------\\n" &&  g++ -std=c++1z -o test %:r.cpp && ./test < input.txt && printf "----------\\n"<CR>',
  { noremap = true }
)
-- Compile and run C++ code with timing
vim.api.nvim_set_keymap(
  "n",
  "<Leader>t",
  ':w<CR>:! printf "Mohitttt your time of execution file is\n*************\n" &&  g++ -std=c++1z -o test %:r.cpp && time ./test < input.txt && printf "*************\n"<CR>',
  { noremap = true }
)
-- Python compile and run the file
vim.api.nvim_set_keymap('n', '<leader>q', [[:w<CR>:! printf "Mohitttt your output is \n*****************************\n" && python3 %:r.py<CR>]], { noremap = true, silent = true })
