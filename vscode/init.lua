
-- This is a minimal Neovim config file for use with the VSCode extension.
-- Its only purpose is to install and configure the multi-cursor plugin.

-- Basic settings for convenience
vim.g.mapleader = " "              -- Set the leader key to Space
if vim.g.vscode then
  vim.g.clipboard = vim.g.vscode_clipboard
else
  vim.opt.clipboard = "unnamedplus"
end
vim.opt.clipboard = "unnamedplus"

-- Keymap for repeated indentation in Visual mode
-- These will be called from keybindings.json for maximum stability.
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = "Indent and re-select" })
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = "De-indent and re-select" })

-- NEW: Remap j and k to move by display lines, not logical lines
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })

-- Center cursor after scrolling with Ctrl+U and Ctrl+D
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })

if vim.g.vscode then
  vim.o.cmdheight = 400
end

-- Bootstrap lazy.nvim package manager
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

-- Setup plugins
require("lazy").setup({
  {
    -- The multi-cursor plugin that mimics VSCode's Ctrl+D functionality.
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      -- Configuration MUST be inside `init` so it is read BEFORE the plugin loads.
      -- This maps the feature to Space + d and prevents conflicts.
      vim.g.VM_maps = {
        ['Find Under'] = '<leader>d',
        ['Find Subword Under'] = '<leader>d',
      }
    end
  },
})

