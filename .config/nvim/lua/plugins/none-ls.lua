-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
--
-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  -- dependencies = {
  -- Adding this as a dependency because some of the default lsps were removed
  -- See https://github.com/nvimtools/none-ls.nvim/discussions/81 for more information
  -- "nvimtools/none-ls-extras.nvim",
  -- },

  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"
    local h = require "null-ls.helpers"
    local cmd_resolver = require "null-ls.helpers.command_resolver"
    local methods = require "null-ls.methods"
    local DIAGNOSTICS = methods.internal.DIAGNOSTICS
    local FORMATTING = methods.internal.FORMATTING

    local standardjsDiagn = h.make_builtin {
      name = "standardjs",
      meta = {
        url = "https://standardjs.com/",
        description = "JavaScript style guide, linter, and formatter.",
      },
      method = DIAGNOSTICS,
      filetypes = { "javascript", "javascriptreact" },
      generator_opts = {
        command = "standard",
        args = { "--stdin" },
        to_stdin = true,
        ignore_stderr = true,
        format = "line",
        check_exit_code = function(c) return c <= 1 end,
        on_output = h.diagnostics.from_patterns {
          {
            pattern = ":(%d+):(%d+): Parsing error: (.*)",
            groups = { "row", "col", "message" },
            overrides = {
              diagnostic = {
                severity = h.diagnostics.severities.error,
              },
            },
          },
          {
            pattern = ":(%d+):(%d+): (.*)",
            groups = { "row", "col", "message" },
            overrides = {
              diagnostic = {
                severity = h.diagnostics.severities.warning,
              },
            },
          },
        },
        dynamic_command = cmd_resolver.from_node_modules(),
      },
      factory = h.generator_factory,
    }

    local standardjsForm = h.make_builtin {
      name = "standardjs",
      meta = {
        url = "https://standardjs.com/",
        description = "JavaScript Standard Style, a no-configuration automatic code formatter that just works.",
      },
      method = FORMATTING,
      filetypes = { "javascript", "javascriptreact" },
      generator_opts = {
        command = "standard",
        args = { "--stdin", "--fix" },
        to_stdin = true,
        dynamic_command = cmd_resolver.from_node_modules(),
      },
      factory = h.formatter_factory,
    }

    null_ls.register(standardjsDiagn)
    null_ls.register(standardjsForm)

    null_ls.setup {
      debug = true,
    }

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
    }
    return config -- return final config table
  end,
}
