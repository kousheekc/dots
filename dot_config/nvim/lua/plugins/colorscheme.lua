return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      -- let kitty's black, semi-transparent background show through
      transparent_background = true,
      color_overrides = {
        mocha = { base = "#11111b", mantle = "#11111b", crust = "#11111b", text = "#bac2de" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
