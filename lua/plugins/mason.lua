if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "mason-org/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        -- list of language servers
        -- except the ones used for LaTeX and CMake
        "basedpyright", -- python static type checker (already in community.lua)
        "bashls", -- bash (already in community.lua)
        "clangd", -- C++ (already in community.lua)
        "jsonls", -- json (already in community.lua)
        "lua_ls", -- lua (already in community.lua)
        "marksman", -- markdown (already in community.lua)
        "neocmake", -- cmake (already in community.lua)
        "ruff", -- python linter and code formatter written in rust (already in community.lua)
        "taplo", -- TOML (already in community.lua)
        "yamlls", -- YAML (already in community.lua)
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        -- list of debuggers
        "bash-debug-adapter", -- bash
        "codelldb", -- C, C++, rust
        "debugpy", -- python (already in community.lua)
      },
    },
  },
}
