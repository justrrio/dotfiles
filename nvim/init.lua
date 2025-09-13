-- init.lua
-- Konfigurasi dasar untuk Neovim

-- Pengaturan dasar
vim.opt.number = true         -- Tampilkan nomor baris
vim.opt.relativenumber = true -- Nomor baris relatif
vim.opt.mouse = 'a'           -- Enable mouse
vim.opt.ignorecase = true     -- Ignore case saat search
vim.opt.smartcase = true      -- Smart case sensitivity
vim.opt.hlsearch = true       -- Jangan highlight hasil search
vim.opt.wrap = false          -- Jangan wrap teks panjang
vim.opt.breakindent = true    -- Maintain indent saat wrap
vim.opt.tabstop = 2           -- Tab width = 2 spaces
vim.opt.shiftwidth = 2        -- Indent width = 2 spaces
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.autoindent = true     -- Auto indent baris baru
vim.opt.termguicolors = true  -- Aktifkan true color support

-- Pengaturan clipboard (penting di Windows!)
vim.opt.clipboard = "unnamedplus"

-- Set leader key (tombol utama untuk shortcut custom)
vim.g.mapleader = " " -- Space sebagai leader key

-- Keymaps dasar
vim.keymap.set('n', '<leader>yp', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
  vim.api.nvim_echo({ { 'File path copied to clipboard!', 'MoreMsg' } }, false, {})
end, { desc = "Copy full file path" })
-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex) -- Kita ganti dengan NvimTree

-- Keymap untuk menghilangkan highlight hasil pencarian
vim.keymap.set('n', '<leader><space>', '<cmd>nohlsearch<CR>', { desc = "Clear search highlight" })

-- Keymaps untuk Code Folding
vim.keymap.set('n', '<leader>za', vim.cmd.foldtoggle, { desc = "Toggle fold" })
vim.keymap.set('n', '<leader>zR', function() require('ufo').openAllFolds() end, { desc = "Open all folds" })
vim.keymap.set('n', '<leader>zM', function() require('ufo').closeAllFolds() end, { desc = "Close all folds" })



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
      -- Dianjurkan untuk menonaktifkan file explorer bawaan (netrw)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup {}

      -- Keymap untuk membuka/menutup NvimTree
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle file explorer" })
    end,
  },

  -- Tabline / Bufferline (seperti tab di VSCode)
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons', -- Untuk ikon file
    config = function()
      require("bufferline").setup({
        options = {
          -- Tampilkan ikon diagnostik (error, warning) dari LSP
          diagnostics = "nvim_lsp",
          -- Selalu tampilkan bufferline, bahkan jika hanya ada 1 tab
          always_show_bufferline = true,
          -- Tampilkan ikon 'x' untuk menutup
          show_buffer_close_icons = true,
          show_close_icon = '',
        }
      })
      -- Keymaps untuk navigasi buffer/tab
      vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = "Next buffer" })
      vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = "Previous buffer" })
      vim.keymap.set('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = "Close current buffer" })
    end
  },

  -- Statusline (baris status di bawah)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          -- Atur tema lualine agar cocok dengan colorscheme utama Anda
          theme = 'moonfly'
        }
      })
    end
  },

  -- Code Folding (UFO - Ultra Fold Organization)
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '1' -- Tampilkan indikator fold di sebelah kiri
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

  -- Indent lines (Garis vertikal untuk indentasi)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}, -- Menggunakan konfigurasi default yang sudah bagus
  },

  -- Commenting (seperti Ctrl+/ di VSCode)
  {
    'numToStr/Comment.nvim',
    opts = {}, -- Ini akan otomatis menjalankan require('Comment').setup()
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
        -- Aktifkan format on save
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      -- Tambahkan shortcut untuk format manual
      vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        require('conform').format({ lsp_fallback = true })
      end, { desc = "Format file or selection" })
    end,
  },

  -- Git signs (Ikon untuk perubahan Git di gutter)
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },


  -- Terminal (Toggleterm)
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- Kita tidak set direction default agar lebih fleksibel
        persistent = true, -- Atur agar sesi terminal tetap ada
      })

      -- Helper function agar bisa keluar dari terminal-mode dengan <esc>
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      end

      -- Panggil function saat terminal dibuka
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Keymaps untuk berbagai jenis terminal dengan ID unik
      -- Terminal 1
      vim.keymap.set("n", "<leader>o1", "<cmd>1ToggleTerm direction=horizontal<CR>", { desc = "Toggle term 1 (H)" })
      -- Terminal 2
      vim.keymap.set("n", "<leader>o2", "<cmd>2ToggleTerm direction=horizontal<CR>", { desc = "Toggle term 2 (H)" })
      -- Terminal 3 (Float)
      vim.keymap.set("n", "<leader>o3", "<cmd>3ToggleTerm direction=float<CR>", { desc = "Toggle term 3 (F)" })
    end,
  },

  -- Telescope (Fuzzy finder yang sangat berguna)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5', -- Versi yang lebih baru
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      -- Shortcut 1: Pencarian normal (Cepat, bersih, menghormati .gitignore)
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })

      -- Shortcut 2: Pencarian file konfigurasi (menampilkan .env, tapi tidak node_modules)
      vim.keymap.set('n', '<leader>fa', function()
        builtin.find_files({
          hidden = true, -- Tampilkan file tersembunyi seperti .env
          find_opts = {
            '--glob',
            '!node_modules', -- Tapi secara eksplisit KECUALIKAN node_modules
          },
        })
      end, { desc = "Find All files (incl. .env)" })

      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set('n', '<leader>xd', builtin.diagnostics, { desc = "List Diagnostics" })
    end
  },

  -- Treesitter (Syntax highlighting yang canggih)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua", "javascript", "typescript", "python", "html", "css", "vim", "vimdoc" },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true, -- Otomatis install parser saat membuka file baru
        folding = { enable = true }
      })
    end
  },

  -- Completion Engine (HARUS ada sebelum LSP!)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", -- Untuk path completion di command line
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", -- Kumpulan snippet berguna
      "onsails/lspkind.nvim",         -- Untuk ikon di completion menu
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
        -- Menambahkan Ikon pada completion menu
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- Menampilkan ikon dan teks
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

      -- Mengaktifkan autocompletion untuk path di command line
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

  -- Mason (Package manager untuk LSP, DAP, linter, formatter)
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

  -- Mason LSP Config (Bridge antara Mason dan nvim-lspconfig)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    -- Tidak perlu config terpisah, akan di-handle di nvim-lspconfig
  },

  -- LSP Config (Konfigurasi utama LSP)
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

      -- Function untuk setup keybindings saat LSP attach
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

      -- Daftar LSP server yang akan di-install otomatis oleh Mason
      local servers = {
        "lua_ls",
        "ts_ls", -- Untuk TypeScript/JavaScript
        "pyright",
        "html",
        "cssls",
        "emmet_ls",
      }

      -- Panggil setup dari mason-lspconfig
      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
      -- Loop untuk setup setiap LSP server dengan nvim-lspconfig
      for _, server_name in ipairs(servers) do
        local settings = {
          capabilities = capabilities,
          on_attach = on_attach,
        }

        -- Konfigurasi khusus untuk lua_ls agar mengenali environment Neovim
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
