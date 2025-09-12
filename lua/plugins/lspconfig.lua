-- adapted from kickstarter
-- https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/lspconfig.lua
-- and AstroLSP configuration
-- https://github.com/AstroNvim/astrolsp?tab=readme-ov-file#nvim-lspconfig--masonnvim--mason-lspconfignvim
-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "AstroNvim/astrolsp",
        dependencies = {
          -- Allows extra capabilities provided by blink.cmp
          "Saghen/blink.cmp",
          "nvim-telescope/telescope.nvim",
        },
        opts = {
          -- Configuration table of features provided by AstroLSP
          features = {
            codelens = true, -- enable/disable codelens refresh on start
            inlay_hints = false, -- enable/disable inlay hints on start
            semantic_tokens = true, -- enable/disable semantic token highlighting
          },
          -- Configure buffer local auto commands to add when attaching a language server
          autocmds = {
            -- first key is the `augroup` (:h augroup)
            lsp_document_highlight = {
              -- condition to create/delete auto command group
              -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
              -- condition will be resolved for each client on each execution and if it ever fails for all clients,
              -- the auto commands will be deleted for that buffer
              cond = "textDocument/documentHighlight",
              -- list of auto commands to set
              {
                -- events to trigger
                event = { "CursorHold", "CursorHoldI" },
                -- the rest of the autocmd options (:h nvim_create_autocmd)
                desc = "Document Highlighting",
                callback = function() vim.lsp.buf.document_highlight() end,
              },
              {
                event = { "CursorMoved", "CursorMovedI", "BufLeave" },
                desc = "Document Highlighting Clear",
                callback = function() vim.lsp.buf.clear_references() end,
              },
            },
            lsp_codelens_refresh = {
              -- Optional condition to create/delete auto command group
              -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
              -- condition will be resolved for each client on each execution and if it ever fails for all clients,
              -- the auto commands will be deleted for that buffer
              cond = "textDocument/codeLens",
              -- cond = function(client, bufnr) return client.name == "lua_ls" end,
              -- list of auto commands to set
              {
                -- events to trigger
                event = { "InsertLeave", "BufEnter" },
                -- the rest of the autocmd options (:h nvim_create_autocmd)
                desc = "Refresh codelens (buffer)",
                callback = function(args)
                  if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
                end,
              },
            },
          },
          -- Configure buffer local user commands to add when attaching a language server
          commands = {
            Format = {
              function() vim.lsp.buf.format() end,
              -- condition to create the user command
              -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
              cond = "textDocument/formatting",
              -- the rest of the user command options (:h nvim_create_user_command)
              desc = "Format file with LSP",
            },
          },
          -- LSP servers and clients are able to communicate to each other what features they support.
          --  By default, Neovim doesn't support everything that is in the LSP specification.
          --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
          --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          defaults = {
            hover = { border = "rounded", silent = true }, -- customize lsp hover window
            signature_help = false, -- disable any default customizations
          },
          -- Configuration of LSP file operation functionality
          file_operations = {
            -- the timeout when executing LSP client operations
            timeout = 10000,
            -- fully disable/enable file operation methods
            operations = {
              willRename = true,
              didRename = true,
              willCreate = true,
              didCreate = true,
              willDelete = true,
              didDelete = true,
            },
          },
          -- A custom flags table to be passed to all language servers  (`:h lspconfig-setup`)
          flags = {
            exit_timeout = 5000,
          },
          -- customize lsp formatting options
          formatting = {
            -- control auto formatting on save
            format_on_save = {
              -- enable or disable format on save globally
              enabled = true,
              -- enable format on save for specified filetypes only
              allow_filetypes = {
                -- "go",
              },
              -- disable format on save for specified filetypes
              ignore_filetypes = {
                "cmake",
                "bash",
              },
            },
            -- disable formatting capabilities for the listed language servers
            disabled = {
              "lua_ls", -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
            },
            -- default format timeout
            timeout_ms = 1000,
            -- fully override the default formatting function
            filter = function(client) return true end,
          },
          -- enable servers
          servers = {
            "basedpyright", -- python static type checker (already in community.lua)
            "bashls", -- bash (already in community.lua)
            "clangd", -- C++ (already in community.lua)
            "jsonls", -- json (already in community.lua)
            "lua_ls", -- lua (already in community.lua)
            "marksman", -- markdown (already in community.lua)
            "neocmake", -- cmake (already in community.lua)
            "ruff", -- python linter and code formatter written in rust (already in community.lua)
            "taplo", -- TOML (already in community.lua)
            "yamlls", -- YAML (already in community.lua),
          },
          -- configure language server for `lspconfig` (`:h lspconfig-setup`)
          ---@diagnostic disable: missing-fields
          config = {
            lua_ls = { -- lua (already in community.lua)
              -- cmd = { ... },
              -- filetypes = { ... },
              -- capabilities = {},
              settings = {
                Lua = {
                  completion = {
                    callSnippet = "Replace",
                  },
                  -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                  -- diagnostics = { disable = { 'missing-fields' } },
                },
              },
            },
            clangd = { -- C++ (already in community.lua)
              capabilities = {
                offsetEncoding = "utf-8",
              },
            },
          },
        },
        handlers = {
          -- default handler, first entry with no key
          function(server, opts) require("lspconfig")[server].setup(opts) end,
        },
        -- Configuration of mappings added when attaching a language server during the core `on_attach` function
        -- The first key into the table is the vim map mode (`:h map-modes`), and the value is a table of entries to be passed to `vim.keymap.set` (`:h vim.keymap.set`):
        --   - The key is the first parameter or the vim mode (only a single mode supported) and the value is a table of keymaps within that mode:
        --   - The first element with no key in the table is the action (the 2nd parameter) and the rest of the keys/value pairs are options for the third parameter.
        --       There is also a special `cond` key which can either be a string of a language server capability or a function with `client` and `bufnr` parameters that returns a boolean of whether or not the mapping is added.
        mappings = {
          -- map mode (:h map-modes)
          x = {
            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            gra = {
              function() vim.lsp.buf.code_action() end,
              desc = "[G]oto Code [A]ction",
            },
          },
          -- map mode (:h map-modes)
          n = {
            -- a binding with no condition and therefore is always added
            gl = {
              function() vim.diagnostic.open_float() end,
              desc = "Hover diagnostics",
            },
            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            grn = {
              function() vim.lsp.buf.rename() end,
              desc = "[R]e[n]ame",
            },
            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            gra = {
              function() vim.lsp.buf.code_action() end,
              desc = "[G]oto Code [A]ction",
            },
            -- Find references for the word under your cursor.
            grr = {
              function() require("telescope.builtin").lsp_references() end,
              desc = "[G]oto [R]eferences",
            },
            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            gri = {
              function() require("telescope.builtin").lsp_implementations() end,
              desc = "[G]oto [I]mplementation",
            },
            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            grd = {
              function() require("telescope.builtin").lsp_definitions() end,
              desc = "[G]oto [D]efinition",
            },
            -- This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            grD = {
              function() vim.lsp.buf.declaration() end,
              desc = "[G]oto [D]eclaration",
              -- condition for only server with declaration capabilities
              cond = "textDocument/declaration",
            },
            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            gO = {
              function() require("telescope.builtin").lsp_document_symbols() end,
              desc = "Open Document Symbols",
            },
            -- Fuzzy find all the symbols in your current workspace.
            --  Similar to document symbols, except searches over your entire project.
            gW = {
              function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
              desc = "Open Workspace Symbols",
            },
            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            grt = {
              function() require("telescope.builtin").lsp_type_definitions() end,
              desc = "[G]oto [T]ype Definition",
            },
            -- condition with a full function with `client` and `bufnr`
            ["<leader>uY"] = {
              function() require("astrolsp.toggles").buffer_semantic_tokens() end,
              desc = "Toggle LSP semantic highlight (buffer)",
              cond = function(client, bufnr)
                return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens
              end,
            },
          },
        },
      },
    },
    {
      "mason-org/mason-lspconfig.nvim", -- MUST be set up before `nvim-lspconfig`
      dependencies = {
        {
          "mason-org/mason.nvim",
          opts = function(_, opts)
            require("astrocore").list_insert_unique(opts.ensure_installed, {
              "latexindent",
              "tectonic",
              "tex-fmt",
            })
          end,
        },

        -- Useful status updates for LSP.
        { "j-hui/fidget.nvim", opts = {} },
      },
      opts = {
        ensure_installed = {
          -- language server needed for latex/tectonic setup
          "texlab",
        },
        -- use AstroLSP setup for mason-lspconfig
        handlers = {
          function(server) -- default handler
            require("astrolsp").lsp_setup(server)
          end,
          -- Next, you can provide targeted overrides for specific servers.
          --   ["texlab"] = function()
          --     require("lspconfig").texlab.setup {
          --       cmd = { "texlab" },
          --       filetypes = { "tex", "bib", ".cls", ".sty" },
          --       -- root_dir = function(filename)
          --       --   local path = "util.path"
          --       --   return path.dirname(filename)
          --       -- end,
          --       settings = {
          --         texlab = {
          --           auxDirectory = ".",
          --           bibtexFormatter = "tex-fmt",
          --           build = {
          --             executable = "tectonic",
          --             args = {
          --               "-X",
          --               "compile",
          --               "%f",
          --               "--synctex",
          --               "--keep-logs",
          --               "--keep-intermediates",
          --             },
          --             forwardSearchAfter = true,
          --             onSave = true,
          --           },
          --           chktex = {
          --             onEdit = false,
          --             onOpenAndSave = false,
          --           },
          --           diagnosticsDelay = 300,
          --           formatterLineLength = 80,
          --           latexFormatter = "tex-fmt",
          --           latexindent = {
          --             modifyLineBreaks = false,
          --           },
          --         },
          --       },
          --     }
          --   end,
        },
      },
      config = function(_, opts)
        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
          severity_sort = true,
          float = { border = "rounded", source = "if_many" },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚 ",
              [vim.diagnostic.severity.WARN] = "󰀪 ",
              [vim.diagnostic.severity.INFO] = "󰋽 ",
              [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
          } or {},
          virtual_text = {
            source = "if_many",
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }
        require("mason-lspconfig").setup(opts)
      end,
    },
    config = function()
      -- set up servers configured with AstroLSP
      vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
      require("lspconfig").texlab.setup {
        cmd = { "texlab" },
        filetypes = { "tex", "bib", ".cls", ".sty" },
        root_dir = function(filename) return vim.fs.dirname(filename) end,
        settings = {
          texlab = {
            auxDirectory = ".",
            bibtexFormatter = "tex-fmt",
            build = {
              executable = "tectonic",
              args = {
                "-X",
                "compile",
                "%f",
                "--synctex",
                "--keep-logs",
                "--keep-intermediates",
              },
              forwardSearchAfter = true,
              onSave = true,
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
              args = {},
            },
            latexFormatter = "tex-fmt",
            latexindent = {
              modifyLineBreaks = false,
            },
          },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
