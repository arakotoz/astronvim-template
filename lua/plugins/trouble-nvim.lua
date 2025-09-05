-- Trouble plugin customization
-- a pretty diagnostics, references, telescope results, quickfix and
-- location list to help you solve all the trouble your code is causing
-- see https://github.com/folke/trouble.nvim
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = {
    { "AstroNvim/astroui", opts = { icons = { Trouble = "󱍼" } } },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<Leader>X"
        maps.n[prefix] = { desc = "Trouble" }
        maps.n[prefix .. "X"] = { "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble Workspace Diagnostics" }
        maps.n[prefix .. "x"] =
          { "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble Document Diagnostics" }
        maps.n[prefix .. "L"] = { "<Cmd>Trouble loclist toggle<CR>", desc = "Trouble Location List" }
        maps.n[prefix .. "Q"] = { "<Cmd>Trouble quickfix toggle<CR>", desc = "Trouble Quickfix List" }
        if require("astrocore").is_available "todo-comments.nvim" then
          maps.n[prefix .. "t"] = { "<cmd>Trouble todo<cr>", desc = "Trouble Todo" }
          maps.n[prefix .. "T"] =
            { "<cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<cr>", desc = "Trouble Todo/Fix/Fixme" }
        end
      end,
    },
  },
  opts = function()
    local get_icon = require("astroui").get_icon
    local lspkind_avail, lspkind = pcall(require, "lspkind")
    return {
      keys = {
        ["<ESC>"] = "close",
        ["q"] = "close",
        ["<C-E>"] = "close",
      },
      icons = {
        indent = {
          fold_open = get_icon "FoldOpened",
          fold_closed = get_icon "FoldClosed",
        },
        folder_closed = get_icon "FolderClosed",
        folder_open = get_icon "FolderOpen",
        kinds = lspkind_avail and lspkind.symbol_map,
      },
    }
  end,
  specs = {
    { "lewis6991/gitsigns.nvim", optional = true, opts = { trouble = true } },
    {
      "folke/edgy.nvim",
      optional = true,
      opts = function(_, opts)
        if not opts.bottom then opts.bottom = {} end
        table.insert(opts.bottom, "Trouble")
      end,
    },
    {
      "sainnhe/everforest",
      optional = true,
      opts = function(_, opts)
        if not opts.integrations then opts.integrations = {} end
        table.insert(opts.integrations, { lsp_trouble = true })
      end,
    },
  },
}
