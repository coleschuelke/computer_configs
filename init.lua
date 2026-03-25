-- 1. Basic Settings
vim.g.mapleader = " "

-- 2. Bootstrap Lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load Plugins
require("lazy").setup({
	-- The Engine (LSP)
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim", config = true },
	{
		"saghen/blink.cmp",
		version = "v0.*",
		opts = {
			keymap = { preset = "super-tab" },
			signature = { enabled = true },
		},
	},
	-- The Aesthetics & Navigation
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- A clean theme
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<c-\>]], -- Use Ctrl-\ to toggle the terminal
			direction = "float", -- 'vertical', 'horizontal', or 'float'
			shade_terminals = true,
		},
	},
	{ "tpope/vim-sleuth" }, -- Auto-detect tabstop and shiftwidth
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				cpp = { "clang-format" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { max_lines = 3 }, -- Don't let it take up too much space
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		opts = {
			-- Optional: shows file sizes and permissions like 'ls -al'
			view_options = {
				show_hidden = true,
			},
			-- This makes it feel more "toggle-like" if you prefer a popup
			float = {
				padding = 2,
				max_width = 90,
				max_height = 0,
			},
			keymaps = {
				["<C-s>"] = "actions.select_split", -- Open in horizontal split
				["<C-v>"] = "actions.select_vsplit", -- Open in vertical split
				["<C-t>"] = "actions.select_tab", -- Open in new tab
				["<C-p>"] = "actions.preview", -- Pop up a preview of the file
			},
		},
		-- Optional: dependencies for icons
		dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true, -- Use Treesitter to check for context
			ts_config = {
				lua = { "string" }, -- Don't add pairs in lua string nodes
				javascript = { "template_string" },
			},
			-- FastWrap: A "Pro" feature for wrapping existing text
			fast_wrap = {
				map = "<M-e>", -- Alt + e to wrap the word ahead in pairs
				chars = { "{", "[", "(", '"', "'" },
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
		},
	},
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
local builtin = require("telescope.builtin")

vim.lsp.config("clangd", { capabilities = capabilities })
vim.lsp.enable("clangd")
vim.lsp.config("pyright", { capabilities = capabilities })
vim.lsp.enable("pyright")
vim.lsp.config("rust_analyzer", { capabilities = capabilities })
vim.lsp.enable("rust_analyzer")

-- 4. Keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {}) -- Find files
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {}) -- Search text in project
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Go to first non-blank" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "Go to end of line" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>t", ":split | term<CR>i", { desc = "Open terminal" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy search in current file" })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal Horizontal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminal Vertical" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil Float" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move block down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move block up" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "Find Diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "*", "*N", { desc = "Search word under cursor without jumping" })

vim.cmd.colorscheme("catppuccin")

-- Misc Options
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.tabstop = 4 -- Number of spaces a \t represents
vim.opt.shiftwidth = 4 -- Number of spaces for auto-indent (>> and <<)
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
