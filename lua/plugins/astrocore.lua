-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = {
        notify = true, -- when a large file is detected
        size = 1024 * 256, -- max file size
        lines = 10000, -- max number of lines
      }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        number = true, -- make line number default
        relativenumber = true, -- use relative line number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        breakindent = true, -- enable break indent
        breakindentopt = { "shift:2", "sbr" }, -- set the shift in number of characters
        cursorline = true, -- highlight which line the cursor is on

        -- inspired by https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

        -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
        ignorecase = true,
        smartcase = true,

        -- Configure how new splits should be opened
        splitright = true,
        splitbelow = true,

        -- Sets how neovim will display certain whitespace characters in the editor.
        --  See `:help 'list'`
        --  and `:help 'listchars'`
        --
        --  Notice listchars is set using `vim.opt` instead of `vim.o`.
        --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
        --   See `:help lua-options`
        --   and `:help lua-options-guide`
        list = true,
        listchars = { tab = "» ", trail = "·", nbsp = "␣" },

        -- Preview substitutions live, as you type!
        inccommand = "split",

        -- Minimal number of screen lines to keep above and below the cursor
        scrolloff = 10,

        -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
        -- instead raise a dialog asking if you wish to save the current file(s)
        -- See `:help 'confirm'`
        confirm = true,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
