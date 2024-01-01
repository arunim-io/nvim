return {
  {
    "numToStr/Comment.nvim",
    config = true,
    event = "BufRead",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    event = "BufRead",
  },
}
