mkdir -p ~/.config/nvim && cat > ~/.config/nvim/init.lua << 'EOF'
vim.g.mapleader = " "

-- Options
local o = vim.opt
o.termguicolors = false        -- use terminal palette
o.background = "dark"
o.number = true
o.relativenumber = false       -- absolute numbers
o.numberwidth = 4
o.cursorline = true
o.signcolumn = "yes"
o.mouse = "a"
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.scrolloff = 8
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
o.showmode = false
o.fillchars = { eob = " " }

-- Terminal-synced highlights (ANSI 0-15 only)
local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end
local function apply_hl()
  hl("Normal",       { ctermbg = "NONE" })
  hl("NormalFloat",  { ctermbg = "NONE" })
  hl("NonText",      { ctermfg = 8, ctermbg = "NONE" })
  hl("SignColumn",   { ctermbg = "NONE" })
  hl("LineNr",       { ctermfg = 8, ctermbg = "NONE" })
  hl("CursorLineNr", { ctermfg = 3, ctermbg = "NONE", cterm = { bold = true } })
  hl("CursorLine",   { ctermbg = 0, cterm = {} })
  hl("Visual",       { ctermbg = 8 })
  hl("Comment",      { ctermfg = 8, cterm = { italic = true } })
  hl("StatusLine",   { ctermfg = 7, ctermbg = 0, cterm = {} })
  hl("StatusLineNC", { ctermfg = 8, ctermbg = 0, cterm = {} })
  hl("WinSeparator", { ctermfg = 8, ctermbg = "NONE" })
  hl("Pmenu",        { ctermfg = 7, ctermbg = 0 })
  hl("PmenuSel",     { ctermfg = 0, ctermbg = 4 })
  hl("IblIndent",    { ctermfg = 0 })
  hl("IblScope",     { ctermfg = 8 })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_hl })

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "nvim-lualine/lualine.nvim",
    opts = { options = { theme = "auto", globalstatus = true,
      section_separators = "", component_separators = "│" } } },

  { "akinsho/bufferline.nvim",
    opts = { options = { separator_style = "thin", diagnostics = "nvim_lsp",
      offsets = { { filetype = "NvimTree", text = "Files" } } } } },

  { "nvim-tree/nvim-tree.lua",
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File tree" } },
    opts = { view = { width = 30 }, renderer = { group_empty = true } } },

  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },
    } },

  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "bash", "python",
          "rust", "c", "javascript", "json", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end },

  { "lewis6991/gitsigns.nvim", opts = {} },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl",
    opts = { indent = { char = "▏" }, scope = { show_start = false, show_end = false } } },

  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
}, { ui = { border = "rounded" } })

-- Keymaps
local map = vim.keymap.set
map("n", "<Tab>",   "<cmd>BufferLineCycleNext<cr>")
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>")
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end })

-- "vim" is the classic ANSI-based colorscheme (Neovim 0.10+)
vim.cmd.colorscheme("vim")
apply_hl()
EOF
