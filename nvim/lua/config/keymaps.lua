-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- leader is a small command palette: space + a verb
map("n", "<leader>w", "<cmd>w<cr>", { desc = "write buffer" })
map("n", "<leader>q", "<cmd>confirm qa<cr>", { desc = "quit nvim" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "clear search" })
map("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", { desc = "explore files" })
map("n", "<leader>ff", "<cmd>lua Snacks.picker.files()<cr>", { desc = "find files" })
map("n", "<leader>fg", "<cmd>lua Snacks.picker.grep()<cr>", { desc = "grep project" })
map("n", "<leader>fr", "<cmd>lua Snacks.picker.recent()<cr>", { desc = "recent files" })
map("n", "<leader>fb", "<cmd>lua Snacks.picker.buffers()<cr>", { desc = "open buffers" })
map("n", "<leader>gg", "<cmd>lua Snacks.lazygit()<cr>", { desc = "lazygit" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "diagnostics" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "code action" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename symbol" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "line diagnostics" })
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<A-j>", ":m .+1<cr>==", { desc = "move line down" })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "move line up" })
map("i", "jk", "<esc>", { desc = "escape" })
