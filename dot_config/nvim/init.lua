-- Basic settings for better markdown experience
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.spell = true
vim.opt.spelllang = { 'en_gb' }

-- Clipboard configuration optimized for Hyprland/Wayland
-- Set up system clipboard integration
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard by default (+ register)

-- Wayland clipboard mappings (Hyprland)
-- Primary selection (middle-click paste)
vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ['+'] = 'wl-copy',
    ['*'] = 'wl-copy --primary',
  },
  paste = {
    ['+'] = 'wl-paste',
    ['*'] = 'wl-paste --primary',
  },
  cache_enabled = 1,
}

-- Enhanced clipboard keymaps for Wayland/Hyprland
-- Visual mode copy
vim.keymap.set('v', '<leader>y', '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set('v', '<leader>p', '"+p', { desc = "Paste from system clipboard" })

-- Normal mode operations
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = "Copy line to system clipboard" })
vim.keymap.set('n', '<leader>pp', '"+p', { desc = "Paste from system clipboard" })

-- Insert mode paste
vim.keymap.set('i', '<C-v>', '<C-r>+', { desc = "Paste from system clipboard" })

-- Spell checking keymaps (when spell is on)
vim.keymap.set('n', '<leader>ss', '<cmd>set spell!<CR>', { desc = "Toggle spell check" })
vim.keymap.set('n', '<leader>sl', function()
  if vim.opt.spelllang:get() == 'en_gb' then
    vim.opt.spelllang = 'en_us'
    print("Spell language: US English")
  else
    vim.opt.spelllang = 'en_gb'
    print("Spell language: British English")
  end
end, { desc = "Toggle US/UK spelling" })
vim.keymap.set('n', '<leader>sp', 'z=', { desc = "Spelling suggestions" })
vim.keymap.set('n', '<leader>sn', ']s', { desc = "Next misspelled word" })
vim.keymap.set('n', '<leader>sp', '[s', { desc = "Previous misspelled word" })
vim.keymap.set('n', '<leader>sa', 'zg', { desc = "Add word to dictionary" })
vim.keymap.set('n', '<leader>si', 'zug', { desc = "Ignore word this session" })

-- Z-key help
vim.keymap.set('n', '<leader>zh', function()
  print("Z-key: zz=center, zt=top, zb=bottom, za=toggle fold, z=spell suggestions, zg=add dict")
end, { desc = "Z-key help" })

-- Enhanced word completion keymaps
vim.keymap.set('i', '<C-n>', function() 
  if vim.fn.pumvisible() == 1 then
    return vim.fn['cmp#visible']() and vim.fn['cmp#select_next_item']() or '\\<C-n>'
  else
    return '\\<C-n>'
  end
end, { expr = true, desc = "Next completion" })

vim.keymap.set('i', '<C-p>', function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['cmp#visible']() and vim.fn['cmp#select_prev_item']() or '\\<C-p>'
  else
    return '\\<C-p>'
  end
end, { expr = true, desc = "Previous completion" })

-- Fallback word completion when cmp menu is not visible
vim.keymap.set('i', '<C-x><C-n>', '<C-n>', { desc = "Word completion (next)" })
vim.keymap.set('i', '<C-x><C-p>', '<C-p>', { desc = "Word completion (previous)" })

-- Omni completion (LSP/syntax aware)
vim.keymap.set('i', '<C-x><C-o>', '<C-o>', { desc = "Omni completion" })

-- Line completion
vim.keymap.set('i', '<C-x><C-l>', '<C-l>', { desc = "Line completion" })

-- File name completion
vim.keymap.set('i', '<C-x><C-f>', '<C-f>', { desc = "File completion" })

-- If wl-clipboard not available, fallback to xclip
if vim.fn.executable('wl-copy') == 0 and vim.fn.executable('xclip') > 0 then
  vim.g.clipboard = {
    name = 'xclip',
    copy = {
      ['+'] = 'xclip -selection clipboard',
      ['*'] = 'xclip -selection primary',
    },
    paste = {
      ['+'] = 'xclip -selection clipboard -o',
      ['*'] = 'xclip -selection primary -o',
    },
    cache_enabled = 1,
  }
end

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

-- Setup lazy.nvim
require("lazy").setup({
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "folke/which-key.nvim" },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "neovim/nvim-lspconfig" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "lewis6991/gitsigns.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline" } },
  
  -- Enhanced completion sources
  { "hrsh7th/cmp-vsnip", dependencies = { "hrsh7th/vim-vsnip" } },
  { "onsails/lspkind-nvim" }, -- Icons for completion
  
  -- Markdown plugins
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      enabled = true,
      -- Configure for your preferences
      heading = { enabled = true, sign = true },
      code = { enabled = true, style = "full" },
      bullet = { enabled = true },
      checkbox = { enabled = true },
      anti_conceal = { enabled = true },
      win_options = {
        conceallevel = { default = 0, rendered = 3 },
        concealcursor = { default = "", rendered = "" }
      }
    },
  },
  {
    "bullets-vim/bullets.vim",
    config = function()
      -- Configure bullets.vim for markdown
      vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit' }
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_delete_last_bullet_if_empty = 1
    end,
  },
})

-- Plugin setups
require('telescope').setup()
require('which-key').setup()
require('nvim-tree').setup()
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  indent = { enable = true },
  -- Ensure markdown parsers are installed
  ensure_installed = { "markdown", "markdown_inline", "lua", "vim", "vimdoc" },
})
require('gitsigns').setup()
require('lualine').setup()
-- Enhanced completion setup
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For vsnip users
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
    })
  },
  -- Enable completion in command line
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
})

-- Markdown-specific keybindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Keybindings for markdown preview
    vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { buffer = true, desc = "Start markdown preview" })
    vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', { buffer = true, desc = "Stop markdown preview" })
    vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<CR>', { buffer = true, desc = "Toggle markdown preview" })
    
    -- Keybindings for render-markdown
    vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<CR>', { buffer = true, desc = "Toggle markdown render" })
    
    -- Ensure treesitter highlights are working
    vim.opt_local.conceallevel = 2
  end,
})
