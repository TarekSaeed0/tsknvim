vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to the left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to the down window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to the up window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to the right window", remap = true })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search highlighting" })

vim.keymap.set("n", "M", "<cmd>Man<cr>", { desc = "Manual" })
