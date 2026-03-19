-- disable netrw since we're using oil.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- reduce log size
vim.lsp.set_log_level("error")

-- 24-bit colour
vim.opt.termguicolors = true

require('packer').startup(function(use)
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- LSP and Autocomplete
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'nvim-tree/nvim-web-devicons'

    -- Oil file explorer
    use {
        'stevearc/oil.nvim',
        config = function()
            require('oil').setup({
                default_file_explorer = true,
                columns = { 'icon' },
                view_options = {
                    show_hidden = false,
                },
            })
        end
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup({})
        end
    }

    use 'tpope/vim-fugitive'
    use {
        'isak102/telescope-git-file-history.nvim',
        requires = {
            'tpope/vim-fugitive',
            'nvim-telescope/telescope.nvim'
        },
        config = function()
            require('telescope').load_extension('git_file_history')
        end
    }

    -- Statusline
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

    -- Theme
    use { 'bluz71/vim-moonfly-colors' }

    -- Commenter
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- Git
    use { 'akinsho/git-conflict.nvim', tag = "*", config = function()
        require('git-conflict').setup()
    end }

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
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
                signcolumn = true,
                numhl      = false,
                linehl     = false,
                word_diff  = false,
                watch_gitdir = { follow_files = true },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                    use_focus = true,
                },
                current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
            })
        end
    }

    -- Window resize
    use {
        "sindrets/winshift.nvim",
        config = function()
            require("winshift").setup()
        end
    }
end)

-- Mason setup (outside packer block to avoid duplicate calls)
require("mason").setup()
require("mason-lspconfig").setup({})

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

-- Colors
vim.cmd [[colorscheme moonfly]]
vim.opt.cursorline = true

-- Leader
vim.g.mapleader = " "

-- Tabs and indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Whitespace characters
vim.opt.list = true
vim.opt.listchars = {
    tab = "→ ",
    trail = "·",
    eol = "↩",
    extends = "▶",
    precedes = "◀",
}

-- Relative numbers
vim.opt.relativenumber = true

-- Foldcolumn
vim.opt.foldcolumn = "auto"

-- Timing
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

-- Winbar
vim.opt.winbar = "%f %m"

-- =====================
-- Keymaps
-- =====================
local opts = { noremap = true, silent = true }

-- Oil - press - to open file explorer in current file's directory
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Diagnostics / LSP
vim.api.nvim_set_keymap('n', '<leader>ii', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.keymap.set('n', '<leader>id', vim.lsp.buf.definition, { desc = 'Go to definition' })

-- Tabs
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tt', ':tabnew | terminal<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabc<CR>', opts)

-- Window navigation
vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', opts)
vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', opts)
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', opts)
vim.api.nvim_set_keymap('n', '<leader>wH', '<C-w>H', opts)
vim.api.nvim_set_keymap('n', '<leader>wJ', '<C-w>J', opts)
vim.api.nvim_set_keymap('n', '<leader>wK', '<C-w>K', opts)
vim.api.nvim_set_keymap('n', '<leader>wL', '<C-w>L', opts)

-- Comments
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts)
vim.api.nvim_set_keymap('v', '<leader>/', '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts)

-- Save/Quit
vim.keymap.set('n', '<leader>ww', ':w<CR>', opts)
vim.keymap.set('n', '<leader>wa', ':wa<CR>', opts)
vim.keymap.set('n', '<leader>qq', ':q<CR>', opts)
vim.keymap.set('n', '<leader>qa', function()
    vim.cmd('mks! s.nvim')
    vim.cmd('qa')
end, opts)

-- Splits
vim.keymap.set('n', 'ss', ':split<CR>', opts)
vim.keymap.set('n', 'sv', ':vsplit<CR>', opts)

-- Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fa', '<cmd>Telescope<cr>', { desc = 'All Telescope commands' })

-- Macros
vim.keymap.set('n', '<leader>ma', '@a')
vim.keymap.set('n', '<leader>ms', '@s')
vim.keymap.set('n', '<leader>md', '@d')
vim.keymap.set('n', '<leader>mm', '@@')

-- Git
vim.keymap.set('n', '<leader>bb', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = 'Toggle git blame' })
vim.keymap.set('n', '<leader>bh', '<cmd>Telescope git_file_history<cr>', { desc = 'Git file history' })

-- LaTeX
vim.keymap.set("n", "<leader>ll", function()
    local file = vim.fn.expand("%")
    vim.cmd("write")
    vim.cmd("!pdflatex " .. file)
end, { desc = "Compile LaTeX" })

vim.keymap.set("n", "<leader>lw", function()
    local file = vim.fn.expand("%")
    vim.cmd("write")
    local output = vim.fn.system({"texcount", file})
    print(output)
end, { desc = "Word count LaTeX" })

-- Blackhole paste
vim.keymap.set('v', '<leader>p', '"_dP')

-- Disable F1 help
vim.api.nvim_set_keymap('', '<F1>', '<Nop>', opts)

-- =====================
-- Commands
-- =====================
vim.api.nvim_create_user_command('Rapport', function()
    local lines = {
        '\\documentclass[12pt, a4paper, oneside]{article}',
        '',
        '\\usepackage[utf8]{inputenc}',
        '\\usepackage[T1]{fontenc}',
        '\\usepackage[a4paper, margin=2cm]{geometry}',
        '',
        '\\usepackage[swedish]{babel}',
        '%\\usepackage[english]{babel}',
        '',
        '\\usepackage[style=authoryear, backend=biber]{biblatex}',
        '\\addbibresource{references.bib}',
        '',
        '\\usepackage{listings}',
        '%\\usepackage{graphicx}',
        '',
        '\\lstset{',
        'basicstyle=\\ttfamily\\bfseries,',
        'breakindent=0pt,',
        'breaklines=true',
        '}',
        '\\title{}',
        '\\author{}',
        '\\date{\\today}',
        '',
        '\\begin{document}',
        '\\maketitle',
        '',
        '',
        '\\end{document}',
    }
    vim.api.nvim_put(lines, 'l', true, true)
end, {})

vim.api.nvim_create_user_command('BF', function()
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = {
        '\\begin{lstlisting}[basicstyle=\\bfseries]',
        '',
        '\\end{lstlisting}'
    }
    vim.api.nvim_buf_set_lines(0, row, row, true, lines)
    vim.api.nvim_win_set_cursor(0, {row + 2, 0})
end, {})

vim.api.nvim_create_user_command('BILD', function()
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = {
        '\\begin{figure}[h]',
        '\\centering',
        '\\includegraphics[width=0.6\\textwidth]{bilder/kursbok.jpg}',
        '\\caption{Kursboks tabell}',
        '\\label{fig:kursbok}',
        '\\end{figure}'
    }
    vim.api.nvim_buf_set_lines(0, row, row, true, lines)
    vim.api.nvim_win_set_cursor(0, {row + 3, 0})
end, {})

vim.api.nvim_create_user_command('Clean', function(o)
    vim.cmd(string.format('%d,%dg/^$/d', o.line1, o.line2))
end, { range = true })

-- open oil at start
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.defer_fn(function()
                require("oil").open(vim.fn.getcwd())
            end, 0)
        end
    end,
})
