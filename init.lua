-- 1. Basic Settings
vim.g.mapleader = " " 
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- 2. Bootstrap Lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load Plugins
require("lazy").setup({
  -- The Engine (LSP)
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim', config = true },
  { 'williamboman/mason-lspconfig.nvim', config = true },
  {
      'saghen/blink.cmp',
      version = 'v0.*',
      opts = {
          keymap = {preset = 'super-tab'},
          signature = {enabled = true}
      }
    }, 
  -- The Aesthetics & Navigation
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- A clean theme
  {
      'akinsho/toggleterm.nvim', 
      version = "*", 
      opts = {
          open_mapping = [[<c-\>]], -- Use Ctrl-\ to toggle the terminal
          direction = 'float',      -- 'vertical', 'horizontal', or 'float'
          shade_terminals = true,
      }
    },
})


local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('clangd', {capabilities = capabilities})
vim.lsp.enable('clangd')
vim.lsp.config('pyright', {capabilities = capabilities})
vim.lsp.enable('pyright')
vim.lsp.config('rust_analyzer', {capabilities = capabilities})
vim.lsp.enable('rust_analyzer')


-- 4. Keymaps (The "Jump Start")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Find files
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})  -- Search text in project
vim.keymap.set({'n', 'v'}, 'H', '^', { desc = 'Go to first non-blank' })
vim.keymap.set({'n', 'v'}, 'L', '$', { desc = 'Go to end of line' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>t', ':split | term<CR>i', { desc = 'Open terminal' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy search in current file' })
vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = 'Terminal Horizontal' })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', { desc = 'Terminal Vertical' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })
vim.cmd.colorscheme "catppuccin"
local builtin = require('telescope.builtin')

-- Undo prefs
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
