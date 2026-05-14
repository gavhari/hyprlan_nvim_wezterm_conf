return {
  -- lazy.nvim
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    config = function()
      require("venv-selector").setup({
        auto_refresh = true,
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },
}
