require("marks").setup {
    builtin_marks = { "", "←", "→", "↑" },
    mappings = {
      set_next = "m,",
      next = "m]",
      preview = "m:",
      set_bookmark0 = "m0",
      prev = false -- pass false to disable only this default mapping
    }
}
