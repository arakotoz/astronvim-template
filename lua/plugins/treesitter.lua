-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "bash",
      "cmake",
      "cpp",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
}
