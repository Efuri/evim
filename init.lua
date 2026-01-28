-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require('packer').startup(function(use)
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Sidebar
    use 'nvim-tree/nvim-web-devicons'

    -- LSP and Autocomplete
    -- Initialize Mason (must run before lspconfig)
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    require("mason").setup()

require("mason").setup()
require("mason-lspconfig").setup({
})

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            -- Bare minimum setup
            require('telescope').setup({})

            -- Two essential keybinds
            vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')  -- Files
            vim.keymap.set('n', '<leader>fd', '<cmd>Telescope file_browser<cr>') -- Dirs
        end
    }
    use 'tpope/vim-fugitive'
    use {
        'isak102/telescope-git-file-history.nvim',
        requires = {
            'tpope/vim-fugitive',     -- Git commands dependency
            'nvim-telescope/telescope.nvim'  -- Main telescope plugin
        },
        config = function()
            require('telescope').load_extension('git_file_history')
        end
    }

    --bottombarr
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    globalstatus = true,
                },
            }
        end
    }

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- Monokai Pro theme
    use ({ 'bluz71/vim-moonfly-colors' }) 

    --commenter
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    -- Git status
    use {'akinsho/git-conflict.nvim', tag = "*", config = function()
        require('git-conflict').setup()
    end}
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                require('gitsigns').setup {
                    signs = {
                        add          = { text = '┃' },
                        change       = { text = '┃' },
                        delete       = { text = '_' },
                        topdelete    = { text = '‾' },
                        changedelete = { text = '~' },
                        untracked    = { text = '┆' },
                    },
                    signs_staged = {
                        add          = { text = '┃' },
                        change       = { text = '┃' },
                        delete       = { text = '_' },
                        topdelete    = { text = '‾' },
                        changedelete = { text = '~' },
                        untracked    = { text = '┆' },
                    },
                    signs_staged_enable = true,
                    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
                    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                    watch_gitdir = {
                        follow_files = true
                    },
                    auto_attach = true,
                    attach_to_untracked = false,
                    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                    current_line_blame_opts = {
                        virt_text = true,
                        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                        delay = 1000,
                        ignore_whitespace = false,
                        virt_text_priority = 100,
                        use_focus = true,
                    },
                    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                    sign_priority = 6,
                    update_debounce = 100,
                    status_formatter = nil, -- Use default
                    max_file_length = 40000, -- Disable if file is longer than this (in lines)
                    preview_config = {
                        -- Options passed to nvim_open_win
                        style = 'minimal',
                        relative = 'cursor',
                        row = 0,
                        col = 1
                    },
                }
            })
        end
    }

    --nvim tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('nvim-tree').setup {
                -- Your existing config
                update_focused_file = {
                    enable = true,
                },
                git = { 
                    enable = true 
                },
                renderer = { 
                    icons = { 
                        show = { 
                            git = true 
                        } 
                    } 
                },

                -- New buffer control additions
                actions = {
                    open_file = {
                        window_picker = {
                            enable = false           -- Prevent window stealing
                        },
                        resize_window = false      -- Don't resize windows
                    }
                },
                hijack_directories = {
                    enable = false               -- Prevent auto-directory focus
                }
            }
        end
    }
    --mouse rezise
    use {
        "sindrets/winshift.nvim",
        config = function()
            require("winshift").setup()
        end
    }
end)

-- Treesitter setup
local ts_status, ts = pcall(require, 'nvim-treesitter.configs')
if ts_status then
    ts.setup {
        ensure_installed = { "lua", "python", "javascript", "html", "cpp" },
        highlight = { enable = true },
    }
else
    print("Treesitter not loaded yet - run :PackerSync")
end

-- Autocomplete setup
local cmp_status, cmp = pcall(require, 'cmp')
if cmp_status then
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = 'nvim_lsp' } },
    })
end

-- Sidebar setup
require("nvim-tree").setup()

-- mappings

-- colors
vim.cmd [[colorscheme moonfly]]
vim.opt.cursorline = true

-- Set leader key to space (if not already set)
vim.g.mapleader = " "

-- Tabs and Indentation
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.shiftwidth = 4         -- Indentation amount for `>>`, `<<`, and `=`
vim.opt.tabstop = 4            -- Number of spaces per tab character
vim.opt.smartindent = true     -- Smart indenting for C-like languages
vim.opt.autoindent = true      -- Copy indent from current line when starting new line

-- Show whitespace characters like spaces, tabs, EOL etc.
vim.opt.list = true            -- Enable showing whitespace characters
vim.opt.listchars = {
    tab = "→ ",                  -- Show tab as → followed by a space
    trail = "·",                 -- Show trailing spaces as ·
    eol = "↩",                   -- Show end of line as ¬
    extends = "▶",               -- Character shown when line continues beyond screen right
    precedes = "◀",              -- Character shown when line continues beyond screen left
}

-- relative Numbers
vim.opt.relativenumber = true

-- Toggle tree
-- 'ee' to focus Nvim Tree
vim.api.nvim_set_keymap('n', '<leader>ee', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
-- 'en' to toggle Nvim Tree
vim.api.nvim_set_keymap('n', '<leader>en', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Toggle diagnostics
vim.api.nvim_set_keymap('n', '<leader>ii', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>id', vim.lsp.buf.definition, { desc = 'Go to definition' })
-- new tab
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true })
-- new tab with terminal
vim.api.nvim_set_keymap('n', '<leader>tt', ':tabnew | terminal<CR>', { noremap = true, silent = true })
-- new tab with terminal
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabc | terminal<CR>', { noremap = true, silent = true })

--window mappping
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', opts)   -- move to left window
vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', opts)   -- move to window below
vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', opts)   -- move to window above
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', opts)   -- move to right window
vim.api.nvim_set_keymap('n', '<leader>wH', '<C-w>H', opts)   -- move to left window
vim.api.nvim_set_keymap('n', '<leader>wJ', '<C-w>J', opts)   -- move to window below
vim.api.nvim_set_keymap('n', '<leader>wK', '<C-w>K', opts)   -- move to window above
vim.api.nvim_set_keymap('n', '<leader>wL', '<C-w>L', opts)   -- move to right window

-- Make sure 'Comment.nvim' is loaded first, then set keymap
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>/', '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })

-- Save current buffer (leader + ww)
vim.keymap.set('n', '<leader>ww', ':w<CR>', opts)

-- Save all buffers (leader + wa)
vim.keymap.set('n', '<leader>wa', ':wa<CR>', opts)

-- Quit current window (leader + qw)
vim.keymap.set('n', '<leader>qq', ':q<CR>', opts)

-- Quit all (leader + qa)
vim.keymap.set('n', '<leader>qa', function()
    vim.cmd('mks! s.nvim')  -- Save session
    vim.cmd('qa')             -- Quit all
end, opts)

-- Splits
vim.keymap.set('n', 'ss', ':split<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'sv', ':vsplit<CR>', { noremap = true, silent = true })

-- telescope bindings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fa', '<cmd>Telescope<cr>', { desc = 'See all Telescope commands' })

-- macro bindings
vim.keymap.set('n', '<leader>ma', '@a')
vim.keymap.set('n', '<leader>ms', '@s')
vim.keymap.set('n', '<leader>md', '@d')
vim.keymap.set('n', '<leader>mm', '@@')

--gitsigns
vim.keymap.set('n', '<leader>bb', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = 'Toggles gitlbame' })
vim.keymap.set('n', '<leader>bh', '<cmd>Telescope git_file_history<cr>', { desc = 'Toggles gitlbame' })

-- latex
vim.keymap.set("n", "<leader>ll", function()
  local file = vim.fn.expand("%")
  vim.cmd("write") -- save first
  vim.cmd("!pdflatex " .. file)
end, { desc = "Compile LaTeX with pdflatex" })

vim.keymap.set("n", "<leader>lw", function()
  local file = vim.fn.expand("%")
  vim.cmd("write")  -- save first
  local output = vim.fn.system({"texcount", file})
  print(output)
end, { desc = "Word count for LaTeX" })










--text shortcuts
--vim.keymap.set("n", "<leader>ii", "i#include <>\27i", { noremap = true })



-- show window bar
vim.opt.winbar = "%f %m"
