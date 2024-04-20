return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.source_selector = {
      winbar = true, -- toggle to show selector on winbar
      statusline = false,
      sources = {
        { source = "filesystem" },
        { source = "git_status" },
      },
    }
    opts.filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignore = false,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          "node_modules",
          "__pycache__",
        },
      },
    }
    return opts
  end,
}
