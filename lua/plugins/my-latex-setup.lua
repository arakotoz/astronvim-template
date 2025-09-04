-- Setup plugins for LaTex

---@type LazySpec
return {
  -- mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "tectonic",
        "bibtex-tidy",
        "tex-fmt",
        "latexindent",
      },
    },
  },
  -- mason-lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "texlab",
      },
      texlab = {
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
            latexFormatter = "tex-fmt",
            latexindent = {
              modifyLineBreaks = false,
            },
          },
        },
      },
    },
  },
}
