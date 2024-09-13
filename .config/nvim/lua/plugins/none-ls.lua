-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
--
-- Customize None-ls sources

local u = require "null-ls.utils"

local function decode_json(filename)
  -- Open the file in read mode
  local file = io.open(filename, "r")
  if not file then
    return false -- File doesn't exist or cannot be opened
  end

  -- Read the contents of the file
  local content = file:read "*all"
  file:close()

  -- Parse the JSON content
  local json_parsed, json = pcall(vim.fn.json_decode, content)
  if not json_parsed or type(json) ~= "table" then
    return false -- Invalid JSON format
  end
  return json
end

local function check_json_key_exists(json, ...) return vim.tbl_get(json, ...) ~= nil end

local has_standard = function()
  local root = vim.fn.getcwd()
  local package_json = decode_json(root .. "/package.json")
  if not package_json then return false end
  return check_json_key_exists(package_json, "devDependencies", "standard")
end

local has_eslint = function()
  local root = vim.fn.getcwd()
  local package_json = decode_json(root .. "/package.json")
  if not package_json then return false end
  return check_json_key_exists(package_json, "devDependencies", "eslint")
end

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  -- dependencies = {
  --   -- Adding this as a dependency because some of the default lsps were removed
  --   -- See https://github.com/nvimtools/none-ls.nvim/discussions/81 for more information
  --   "nvimtools/none-ls-extras.nvim",
  -- },

  opts = function(_, opts)
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

    local eslintForm = h.make_builtin {
      name = "eslint-form",
      meta = {
        url = "https://github.com/eslint/eslint",
        description = "Find and fix problems in your JavaScript code.",
      },
      method = FORMATTING,
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
      },
      factory = h.generator_factory,
      generator_opts = {
        command = "eslint",
        args = { "--fix-dry-run", "--format", "json", "--stdin", "--stdin-filename", "$FILENAME" },
        to_stdin = true,
        format = "json",
        on_output = function(params)
          local parsed = params.output[1]
          return parsed
            and parsed.output
            and {
              {
                row = 1,
                col = 1,
                end_row = #vim.split(parsed.output, "\n") + 1,
                end_col = 1,
                text = parsed.output,
              },
            }
        end,
        dynamic_command = cmd_resolver.from_node_modules(),
        check_exit_code = { 0, 1 },
        cwd = h.cache.by_bufnr(function(params) return u.cosmiconfig("eslint", "eslintConfig")(params.bufname) end),
      },
    }

    if has_standard() then
      null_ls.register(standardjsDiagn)
      null_ls.register(standardjsForm)
    end

    if has_eslint() then null_ls.register(eslintForm) end

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    --
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Set a formatter
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier.with {
        condition = function(utils)
          return utils.root_has_file {
            ".prettierrc",
            ".prettierrc.js",
            ".prettierrc.json",
            ".prettierrc.toml",
            ".prettierrc.yaml",
            ".prettierrc.yml",
          }
        end,
      },
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
      -- require "none-ls.formatting.eslint",
    })
    return opts -- return final config table
  end,
}
