-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "nord"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

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
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- MARCO -----------------------------------------
-- Map tab and shift-tab for buffer switching
lvim.keys.normal_mode["<tab>"] = ":if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>"
lvim.keys.normal_mode["<s-tab>"] = ":if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>"

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "standardjs" },
  { name = "prettier" },
}

-- COPILOT
lvim.plugins = {
  { "arcticicestudio/nord-vim" },
  { "github/copilot.vim" },
  { "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
        }
      end, 100)
    end,
  },

  { "zbirenbaum/copilot-cmp",
    after = { "copilot.lua", "nvim-cmp" },
  },
}
-- Can not be placed into the config method of the plugins.
lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })

-- Disable tsserver and enable eslint for TS
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "eslint", "tsserver" })
-- local tsserver_opts = {
--   filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
-- }
-- require("lvim.lsp.manager").setup("tsserver", tsserver_opts)

-- disable the TS warnings
require 'lspconfig'.tsserver.setup {
  handlers = {
    ['textDocument/publishDiagnostics'] = function() end,
  },
}
