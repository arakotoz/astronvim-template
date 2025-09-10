if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Setup plugins for LaTex
local handlers = {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {}
  end,
  -- Next, you can provide targeted overrides for specific servers.
  ["texlab"] = function()
    local lspconfig = require "lspconfig"
    lspconfig.texlab.setup {
      settings = {
        texlab = {
          auxDirectory = ".",
          bibtexFormatter = "bibtex-tidy",
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
          latexFormatter = "tex-fmt",
          latexindent = {
            modifyLineBreaks = false,
          },
        },
      },
    }
  end,
}

---@type LazySpec
return {
  -- mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      require("astrocore").list_insert_unique(opts.ensure_installed, {
        "tectonic",
        "bibtex-tidy",
        "tex-fmt",
        "latexindent",
      })
    end,
  },
  -- mason-lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      require("astrocore").list_insert_unique(opts.ensure_installed, { "texlab" })
      require("mason-lspconfig").setup_handlers(handlers)
    end,
  },
}
