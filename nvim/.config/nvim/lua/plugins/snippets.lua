-- Custom snippets configuration
return {
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      -- Load default LazyVim config
      if opts then
        require("luasnip").config.setup(opts)
      end

      -- Load custom VSCode-style snippets
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
    end,
  },
}
