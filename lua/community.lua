-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- pack
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },
  -- bars-and-lines
  { import = "astrocommunity.bars-and-lines.lualine-nvim" },
  -- colorscheme
  { import = "astrocommunity.colorscheme.everforest" },
  -- completion
  { import = "astrocommunity.completion.coq_nvim" },
  -- editing support
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  -- git
  { import = "astrocommunity.git.diffview-nvim" },
  -- markdown and latex
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  -- recipes
  { import = "astrocommunity.recipes.neovide" },
}
