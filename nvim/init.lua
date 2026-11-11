-- Custom Neovim config - LazyVim removed, plugins kept

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Basic setup
vim.opt.termguicolors = true
vim.opt.list = false
vim.g.lazyvim_check_order = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- WASD movement (overrides default)
vim.keymap.set({ "n", "v" }, "w", "k", { noremap = true, silent = true, desc = "Move Up" })
vim.keymap.set({ "n", "v" }, "a", "h", { noremap = true, silent = true, desc = "Move Left" })
vim.keymap.set({ "n", "v" }, "s", "j", { noremap = true, silent = true, desc = "Move Down" })
vim.keymap.set({ "n", "v" }, "d", "l", { noremap = true, silent = true, desc = "Move Right" })

-- Force WASD
vim.keymap.set({ "n", "v" }, "h", "w", { noremap = true, silent = true, desc = "Next Word" })
vim.keymap.set({ "n", "v" }, "j", "a", { noremap = true, silent = true, desc = "Append Text" })
vim.keymap.set({ "n", "v" }, "k", "s", { noremap = true, silent = true, desc = "Substitute Character" })
vim.keymap.set({ "n", "v" }, "l", "d", { noremap = true, silent = true, desc = "Delete Operator" })
vim.keymap.set({ "n", "v" }, "ll", "dd", { noremap = true, silent = true, desc = "Delete Current Line" })

-- Disable arrow keys
local arrows = { "<Up>", "<Down>", "<Left>", "<Right>" }
for _, key in ipairs(arrows) do
  vim.keymap.set({ "n", "v", "o" }, key, "<Nop>", { noremap = true, silent = true })
end

-- Load custom plugin spec
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "matugen", "tokyonight" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})
