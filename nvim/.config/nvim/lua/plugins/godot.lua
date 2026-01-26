-- Godot/GDScript support
return {
  -- GDScript syntax highlighting via treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gdscript",
        "godot_resource",
      })
    end,
  },

  -- GDScript LSP (connects to running Godot editor)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {},
      },
      setup = {
        gdscript = function(_, opts)
          local lspconfig = require("lspconfig")
          lspconfig.gdscript.setup({
            cmd = { "nc", "localhost", "6005" },
            filetypes = { "gd", "gdscript", "gdscript3" },
            root_dir = lspconfig.util.root_pattern("project.godot", ".git"),
          })
          return true
        end,
      },
    },
  },
}
