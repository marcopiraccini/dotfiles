https://github.com/stevearc/resession.nvim

dirsessions are saved in: /home/marco/.local/share/nvim/dirsession

neovim:

- Refresh: R
- Change source: < >
  ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
  ["d"] = "delete",
  ["r"] = "rename",
  ["y"] = "copy_to_clipboard",
  ["x"] = "cut_to_clipboard",
  ["p"] = "paste_from_clipboard",
  ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
  -- ["c"] = {
  -- "copy",
  -- config = {
  -- show_path = "none" -- "none", "relative", "absolute"
  -- }
  --}
  ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
  ["q"] = "close_window",
  ["R"] = "refresh",
  ["?"] = "show_help",
  ["<"] = "prev_source",
  [">"] = "next_source",
  ["i"] = "show_file_details",
