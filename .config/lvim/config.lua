-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "nord"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- CTRL-S to save
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- CTRL-N to toggle the tree
lvim.keys.normal_mode["<C-n>"] = ":NvimTreeToggle<cr>"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.direction = "float"
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true


lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeFindFileToggle<CR>", "Explorer" }
lvim.builtin.alpha.dashboard.section.header.val = {
  "",
  "",
  [[  ____             _                ]],
  [[ |  _ \  __ _ _ __| | ____ ___   __ ]],
  [[ | | | |/ _` | '__| |/ / _` \ \ / / ]],
  [[ | |_| | (_| | |  |   < (_| |\ V /  ]],
  [[ |____/ \__,_|_|  |_|\_\__,_| \_/   ]],
  [[                                    ]],
  "",
  "",
}

-- if you don't want all the parsers change this to a table of the ones you want
lvim.lsp.installer.setup.automatic_installation = false -- HAS TO BE SET TO FALSE OR ISSUE PERSITS
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "cpp",
  "cmake",
  "commonlisp",
  "dart",
  "dockerfile",
  "fish",
  "go",
  "gomod",
  "graphql",
  "html",
  "jsdoc",
  "kotlin",
  "r",
  "ruby",
  "scala",
  "vim",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "svelte",
  "rust",
  "toml",
  "java",
  "yaml",
  "norg",
  "markdown"
}

lvim.builtin.treesitter.highlight.enabled = true

-- Map H/L for buffer switching
lvim.keys.normal_mode["L"] = ":if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>"
lvim.keys.normal_mode["H"] = ":if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>"

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "standardjs" }
}

lvim.plugins = {
  { "arcticicestudio/nord-vim" },
  { "github/copilot.vim" },
  { "zbirenbaum/copilot-cmp",
    after = { "copilot.lua", "nvim-cmp" },
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "ChristianChiarulli/bookmark.nvim",
    dependencies = {
      "kkharji/sqlite.lua"   
    },
    config = function()
      require("bookmark").setup {
        -- Options Here
        sign = "",
        highlight = "Function",
      }
      require("telescope").load_extension('bookmark')
    end,
  }
}
-- Can not be placed into the config method of the plugins.
lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })

-- TS parameters
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })
local tsserver_opts = {
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" },
  -- https://github.com/typescript-language-server/typescript-language-server#initializationoptions
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
}
require("lvim.lsp.manager").setup("tsserver", tsserver_opts)
require("lvim.lsp.manager").setup "marksman"
-- require("lvim.lsp.manager").setup "grammarly"

require("lvim.lsp.manager").setup "tailwindcss"

-- TEMPORARY, see: https://github.com/LunarVim/LunarVim/issues/2993#issuecomment-1239178800
lvim.builtin.bufferline.options.indicator_icon = nil
lvim.builtin.bufferline.options.indicator = { style = "icon", icon = "▎" }

-- VIM opts
vim.opt.showmode = true
vim.opt.wrap = true

-- https://github.com/orgs/community/discussions/16800
vim.g.copilot_node_command = "~/.nvm/versions/node/v16.16.0/bin/node"
vim.g.copilot_assume_mapped = true
vim.g.copilot_filetypes = {
  ["*"] = true,
  ["javascript"] = true,
  ["typescript"] = true,
  ["rust"] = true,
  ["c"] = true,
  ["c#"] = true,
  ["c++"] = true,
  ["go"] = true,
  ["python"] = true,
}

vim.api.nvim_set_keymap('i', '<C-Right>', 'copilot#Accept("<CR>")', { expr = true, silent = true })
vim.api.nvim_set_keymap('', '<S-Esc>', "<ESC>:noh<CR>", { silent = true })

-- Bookmark
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
keymap("n", "<Space><Down>", "<cmd>BookmarkNext<cr>", opts)
keymap("n", "<Space><Up>", "<cmd>BookmarkPrev<cr>", opts)
keymap("n", "<Space>B", "<cmd>BookmarkToggle<cr>", opts)
keymap("n", "<Space><Right>", "<cmd>FilemarkNext<cr>", opts)
keymap("n", "<Space><Left>", "<cmd>FilemarkPrev<cr>", opts)
keymap("n", "<Space>F", "<cmd>FilemarkToggle<cr>", opts)
keymap(
  "n",
  "<tab>",
  "<cmd>lua require('telescope').extensions.bookmark.filemarks(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal', prompt_title='Filemarks'})<cr>",
  opts
)
