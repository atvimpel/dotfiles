vim.opt.termguicolors = true -- matugen writes guifg/guibg; nvim ignores them without this
vim.opt.list = false

-- system clipboard (Wayland: needs wl-clipboard; X11: needs xclip/xsel)
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- ── LINE NUMBER DESIGN CONFIGURATION ──
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.laststatus = 3
vim.opt.fillchars = { eob = " ", vert = "│", fold = "·", foldopen = "▾", foldclose = "▸" }
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.wrap = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- Keymaps & Utility Configs
vim.keymap.set({ "i", "c" }, "`", "<Esc>", { noremap = true, silent = true })
vim.keymap.set({ "i", "c" }, "<C-Left>", "<C-o>b", { noremap = true, silent = true })
vim.keymap.set({ "i", "c" }, "<C-Right>", "<C-o>w", { noremap = true, silent = true })
vim.keymap.set("c", "<C-Right>", "<C-f>w", { noremap = true, silent = true })
vim.keymap.set({ "i", "c" }, "<C-H>", "<C-w>", { noremap = true, silent = true })
vim.keymap.set({ "i", "c" }, "<C-bs>", "<C-w>", { noremap = true, silent = true })
vim.opt.guicursor = "v-i-c:ver25-blinkwait1000-blinkon1000-blinkoff1000"

-- plain built-in statusline; avoids lualine's generated angle-bracket
-- expression on this neovim build
vim.opt.statusline = "  %M%f  %=  %y  |  %l:%c  %p%%  "
