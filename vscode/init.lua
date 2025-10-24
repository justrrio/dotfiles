-- This is a minimal Neovim config file for use with the VSCode extension.
-- Its only purpose is to install and configure the multi-cursor plugin.

-- Basic settings for convenience
vim.g.mapleader = " " -- Set the leader key to Space

-- Use the stable, extension-provided clipboard method when inside VSCode,
-- and fall back to the system clipboard (requires xclip on Linux) otherwise.
if vim.g.vscode then
  vim.g.clipboard = vim.g.vscode_clipboard
else
  vim.opt.clipboard = "unnamedplus"
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
