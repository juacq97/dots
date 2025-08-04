require("config.lazy")

-- Leader key como espacio
vim.g.mapleader = ' '

-- Opciones generales de Vim
vim.opt.compatible = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wildmenu = true
vim.opt.linebreak = true
vim.opt.hidden = true
vim.opt.laststatus = 2
vim.opt.textwidth = 0
vim.opt.formatoptions:append('t')
vim.opt.termguicolors = false
vim.cmd("syntax enable")
vim.opt.conceallevel = 0

-- Statusline
vim.opt.statusline = "%#Question#%=%#Question#%F%m%r %y %#VisualNC# %l,%c  %P"
vim.cmd(":hi statusline guibg=NONE")

-- Comportamiento
vim.opt.autoread = true
vim.cmd [[
  augroup autoread_check
    autocmd!
    autocmd FocusGained,BufEnter * checktime
  augroup END
]]
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.virtualedit = "block"
vim.opt.backspace = { "eol", "start", "indent" }
vim.opt.whichwrap:append("<,>,h,l")
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.opt.mouse = "a"
vim.cmd [[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]

-- Movimiento con j/k inteligente
vim.keymap.set({ "n", "v" }, "j", [[v:count > 4 ? "m'" . v:count . 'j' : 'gj']], { expr = true })
vim.keymap.set({ "n", "v" }, "k", [[v:count > 4 ? "m'" . v:count . 'k' : 'gk']], { expr = true })

-- Teclas desactivadas
vim.keymap.set("n", "q:", "<Nop>", { noremap = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true })

