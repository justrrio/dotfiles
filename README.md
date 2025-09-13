

# My Personal Neovim Configuration

Welcome to my Neovim dotfiles!
This is a configuration designed to be a **modern, fast, and efficient editor** for daily development, especially in a Windows environment.
The main philosophy is to take the best features from VSCode and bring them into the speed and power of Neovim.

---

## ✨ Key Features

* **Modern Plugin Manager**
  Uses `lazy.nvim` for extremely fast and manageable plugin loading.

* **IDE-like Appearance**
  Equipped with a file explorer (`nvim-tree`), tabs (`bufferline`), and an informative statusline (`lualine`).

* **Smart Search**
  Utilizes `telescope.nvim` for super-fast fuzzy finding of files, text, buffers, and more.

* **Full LSP Support**
  Automatic configuration for the Language Server Protocol via `mason.nvim`, providing accurate autocompletion, diagnostics, and go-to-definition.

* **Advanced Autocompletion**
  Powered by `nvim-cmp` with sources from LSP, snippets, and paths, complete with visual icons.

* **Auto-formatting**
  Code is automatically formatted on save using `conform.nvim` with support for Prettier, Black, and others.

* **Git Integration**
  Displays Git change indicators directly next to the line numbers with `gitsigns.nvim`.

* **Multi-Cursor Workflow**
  Features a word selection workflow similar to `Ctrl+D` in VSCode.

* **Integrated Terminal**
  Opens multiple terminals directly inside Neovim as splits or floating windows with `toggleterm.nvim`.

* **Smart Code Folding**
  Intelligently folds and unfolds code blocks based on the structure from `nvim-treesitter`.

---

## 🔌 Plugin List

| Plugin                                | Description                              |
| ------------------------------------- | ---------------------------------------- |
| `folke/lazy.nvim`                     | Plugin Manager                           |
| `bluz71/vim-moonfly-colors`           | Main Colorscheme                         |
| `nvim-tree/nvim-tree.lua`             | File Explorer                            |
| `akinsho/bufferline.nvim`             | Displays open buffers as tabs            |
| `nvim-lualine/lualine.nvim`           | Informative and beautiful statusline     |
| `kevinhwang91/nvim-ufo`               | Engine for fast Code Folding             |
| `lukas-reineke/indent-blankline.nvim` | Displays vertical indent lines           |
| `numToStr/Comment.nvim`               | Comment code with `gc` (like Ctrl+/)     |
| `stevearc/conform.nvim`               | Engine for auto-formatting code          |
| `lewis6991/gitsigns.nvim`             | Git integration in the gutter            |
| `mg979/vim-visual-multi`              | Multi-cursor like Ctrl+D in VSCode       |
| `akinsho/toggleterm.nvim`             | Advanced integrated terminal             |
| `nvim-telescope/telescope.nvim`       | Fuzzy finder for everything              |
| `nvim-treesitter/nvim-treesitter`     | Syntax highlighting and code structure   |
| `hrsh7th/nvim-cmp`                    | Autocompletion Engine                    |
| `williamboman/mason.nvim`             | Manager for LSP, formatters, and linters |
| `neovim/nvim-lspconfig`               | Basic configuration for LSP              |

---

## ⌨️ Important Shortcuts

`<leader>` is set to the **Space** key.

### Navigation & File Management

| Shortcut      | Action                                        |
| ------------- | --------------------------------------------- |
| `<leader> e`  | Toggle File Explorer (nvim-tree)              |
| `<Tab>`       | Go to next tab / buffer                       |
| `<S-Tab>`     | Go to previous tab / buffer                   |
| `<leader> bc` | Close current buffer                          |
| `<leader> ff` | Find files in the entire project              |
| `<leader> fa` | Find files (including hidden files like .env) |
| `<leader> fg` | Search for text in the project (Live Grep)    |
| `<leader> fb` | Find from open buffers                        |
| `<leader> yp` | Copy full path of the current file            |

### Writing & Editing Code

| Shortcut              | Action                                                    |
| --------------------- | --------------------------------------------------------- |
| `gcc`                 | Toggle comment for the current line                       |
| `gc` (in Visual)      | Toggle comment for the selected block                     |
| `<leader> f`          | Format code manually                                      |
| `<C-d>` (in Normal)   | Select word under cursor & next occurrence                |
| `<leader> rn`         | Intelligently rename variable/function (Rename)           |
| `>` / `<` (in Visual) | Indent / De-indent repeatedly without leaving Visual mode |

### Diagnostics & Errors

| Shortcut      | Action                                             |
| ------------- | -------------------------------------------------- |
| `<leader> vd` | View error details on the current line             |
| `<leader> xd` | Open list of all errors in the project (Telescope) |
| `[d` / `]d`   | Go to previous / next error                        |

### Miscellaneous

| Shortcut           | Action                              |
| ------------------ | ----------------------------------- |
| `<leader> o1`      | Toggle Terminal #1 (Horizontal)     |
| `<leader> o2`      | Toggle Terminal #2 (Horizontal)     |
| `<leader> o3`      | Toggle Terminal #3 (Floating)       |
| `<leader> za`      | Toggle current code fold            |
| `<leader> zR`      | Open all folds in the file          |
| `<leader> zM`      | Close all folds in the file         |
| `<leader> <space>` | Clear highlight from search results |
