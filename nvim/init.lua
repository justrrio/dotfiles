-- init.lua
-- Basic configuration for Neovim

-- Basic settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.mouse = 'a'           -- Enable mouse
vim.opt.ignorecase = true     -- Ignore case when searching
vim.opt.smartcase = true      -- Smart case sensitivity
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.cursorline = true     -- Highlight the current cursor line
vim.opt.wrap = false          -- Do not wrap long text
vim.opt.breakindent = true    -- Maintain indent when wrapping
vim.opt.tabstop = 2           -- Tab width = 2 spaces
vim.opt.shiftwidth = 2        -- Indent width = 2 spaces
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.autoindent = true     -- Auto indent new lines
vim.opt.termguicolors = true  -- Enable true color support

-- Folding settings
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99 -- Open file with all folds expanded

-- Clipboard settings (important on Windows!)
vim.opt.clipboard = "unnamedplus"

-- Set leader key (main key for custom shortcuts)
vim.g.mapleader = " " -- Space as leader key

-- Basic keymaps
vim.keymap.set('n', '<leader>yp', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
  vim.api.nvim_echo({ { 'File path copied to clipboard!', 'MoreMsg' } }, false, {})
end, { desc = "Copy full file path" })
-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex) -- We replace it with NvimTree

-- Keymap to clear search highlights
vim.keymap.set('n', '<leader><space>', '<cmd>nohlsearch<CR>', { desc = "Clear search highlight" })

-- Keymap for repeated indentation in Visual mode
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = "Indent and re-select" })
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = "De-indent and re-select" })


-- Bootstrap lazy.nvim
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

require("lazy").setup({
  -- Colorscheme
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "moonfly"
    end
  },

  -- File Explorer: NvimTree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Recommended: disable built-in file explorer (netrw)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        -- MODIFICATION: Disable error recognition from nvim-tree
        diagnostics = {
          enable = false,
        },
        git = {
          enable = false,
        }
      })

      -- Keymap to toggle NvimTree
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle file explorer" })
    end,
  },

  -- FIX: Added back the bufferline block that was missing/broken
  -- Tabline / Bufferline (like tabs in VSCode)
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons', -- For file icons
    config = function()
      require("bufferline").setup({
        options = {
          -- Show diagnostic icons (error, warning) from LSP
          diagnostics = "nvim_lsp",
          -- Always show bufferline even if only one tab
          always_show_bufferline = true,
          -- Show 'x' icon to close
          show_buffer_close_icons = true,
          show_close_icon = '',
        }
      })
      -- Keymaps for buffer/tab navigation
      vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = "Next buffer" })
      vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = "Previous buffer" })
      vim.keymap.set('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = "Close current buffer" })
    end
  },

  -- Code Folding (UFO - Ultra Fold Organization)
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '1' -- Show fold indicator on the left
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end
  },

  -- Statusline (status bar at the bottom)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          -- Set lualine theme to match your main colorscheme
          theme = 'moonfly'
        }
      })
    end
  },

  -- Indent lines (vertical lines for indentation)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}, -- Using good default config
  },

  -- Commenting (like Ctrl+/ in VSCode)
  {
    'numToStr/Comment.nvim',
    opts = {}, -- This will automatically run require('Comment').setup()
  },

  -- Auto-formatting (Conform)
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          python = { "ruff_format", "black" },
        },
        -- Enable format on save
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      -- Add manual format shortcut
      vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        require('conform').format({ lsp_fallback = true })
      end, { desc = "Format file or selection" })
    end,
  },

  -- Git signs (icons for Git changes in the gutter)
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Multi-cursor editing (like Ctrl+D in VSCode)
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      -- Configuration MUST be inside `init` so it is read BEFORE the plugin loads.
      -- This prevents issues where the shortcut deletes text instead.
      vim.g.VM_maps = {
        ['Find Under'] = '<leader>d', -- Main shortcut like in VSCode
        ['Find Subword Under'] = '<leader>d',
      }
    end
  },

  -- Terminal (Toggleterm)
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- We don’t set a default direction for more flexibility
        persistent = true, -- Keep terminal sessions
      })

      -- Helper function to exit terminal-mode with <esc>
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      end

      -- Call function when terminal opens
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Keymaps for different terminal IDs
      -- Terminal 1
      vim.keymap.set("n", "<leader>o1", "<cmd>1ToggleTerm direction=horizontal<CR>", { desc = "Toggle term 1 (H)" })
      -- Terminal 2
      vim.keymap.set("n", "<leader>o2", "<cmd>2ToggleTerm direction=horizontal<CR>", { desc = "Toggle term 2 (H)" })
      -- Terminal 3 (Float)
      vim.keymap.set("n", "<leader>o3", "<cmd>3ToggleTerm direction=float<CR>", { desc = "Toggle term 3 (F)" })
    end,
  },

  -- Telescope (Super useful fuzzy finder)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5', -- Newer version
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      -- Shortcut 1: Normal search (fast, clean, respects .gitignore)
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })

      -- Shortcut 2: Config file search (shows .env but excludes node_modules)
      vim.keymap.set('n', '<leader>fa', function()
        builtin.find_files({
          hidden = true, -- Show hidden files like .env
          find_opts = {
            '--glob',
            '!node_modules', -- Explicitly EXCLUDE node_modules
          },
        })
      end, { desc = "Find All files (incl. .env)" })

      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set('n', '<leader>xd', builtin.diagnostics, { desc = "List Diagnostics" })
    end
  },

  -- Treesitter (Advanced syntax highlighting)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua", "javascript", "typescript", "python", "html", "css", "vim", "vimdoc" },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,         -- Automatically install parser when opening new files
        folding = { enable = true }, -- ENABLE FOLDING FEATURE
      })
    end
  },

  -- Completion Engine (MUST be before LSP!)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", -- For path completion in command line
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", -- Useful snippet collection
      "onsails/lspkind.nvim",         -- For icons in completion menu
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        -- Add icons to the completion menu
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- Show icon and text
            maxwidth = 50,
            ellipsis_char = '...',
          }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
      })

      -- Enable autocompletion for paths in command line
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  },

  -- Mason (Package manager for LSP, DAP, linters, formatters)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },

  -- Mason LSP Config (Bridge between Mason and nvim-lspconfig)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    -- No separate config needed, handled in nvim-lspconfig
  },

  -- LSP Config (Main LSP configuration)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Function to set keybindings when LSP attaches
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
      end

      -- List of LSP servers to auto-install via Mason
      local servers = {
        "lua_ls",
        "ts_ls", -- For TypeScript/JavaScript
        "pyright",
        "html",
        "cssls",
        "emmet_ls",
      }

      -- Call setup from mason-lspconfig
      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
      -- Loop to set up each LSP server with nvim-lspconfig
      for _, server_name in ipairs(servers) do
        local settings = {
          capabilities = capabilities,
          on_attach = on_attach,
        }

        -- Special configuration for lua_ls to recognize Neovim environment
        if server_name == "lua_ls" then
          settings.settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false },
            },
          }
        end

        lspconfig[server_name].setup(settings)
      end
    end
  }
})
