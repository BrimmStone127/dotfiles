-- Custom configuration for your workflow

-- Set leader key reminder
-- Leader key is Space in LazyVim

-- Custom keymaps
local keymap = vim.keymap.set

-- Save file with Ctrl-s (in addition to Space-w)
keymap("n", "<C-s>", ":w<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })

-- Quick access to config
keymap("n", "<leader>vc", ":e ~/.config/nvim/lua/config/custom.lua<CR>", { desc = "Edit custom config" })

-- Better window navigation (in addition to Ctrl-h/j/k/l)
keymap("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- Quick note taking
keymap("n", "<leader>nn", ":e ~/notes/daily/" .. os.date("%Y-%m-%d") .. ".md<CR>", { desc = "Daily note" })
keymap("n", "<leader>nw", ":e ~/notes/work.md<CR>", { desc = "Work notes" })
keymap("n", "<leader>nt", ":e ~/notes/todo.md<CR>", { desc = "Todo list" })

-- Copy to Windows clipboard
keymap("v", "<leader>y", ":'<,'>w !clip.exe<CR><CR>", { desc = "Copy to Windows clipboard" })

print("Custom config loaded!")
