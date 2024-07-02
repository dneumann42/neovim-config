return {
  "coffebar/neovim-project",
  opts = {
    projects = {
      os.getenv("HOME") .. "/.repos/*",
    }
  },
  init = function()
        -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  datapath = vim.fn.stdpath("data"), -- ~/.local/share/nvim/
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100
}
