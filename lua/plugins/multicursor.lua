return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      -- Add/skip cursor above/below the main cursor.
      { "<up>", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "x" }, desc = "Multicursor: add cursor above" },
      { "<down>", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "x" }, desc = "Multicursor: add cursor below" },
      { "<leader><up>", function() require("multicursor-nvim").lineSkipCursor(-1) end, mode = { "n", "x" }, desc = "Multicursor: skip cursor above" },
      { "<leader><down>", function() require("multicursor-nvim").lineSkipCursor(1) end, mode = { "n", "x" }, desc = "Multicursor: skip cursor below" },

      -- Add/skip matching word/selection under cursor.
      { "<leader>n", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "x" }, desc = "Multicursor: add next match" },
      { "<leader>N", function() require("multicursor-nvim").matchAddCursor(-1) end, mode = { "n", "x" }, desc = "Multicursor: add prev match" },
      { "<leader>k", function() require("multicursor-nvim").matchSkipCursor(1) end, mode = { "n", "x" }, desc = "Multicursor: skip next match" },
      { "<leader>K", function() require("multicursor-nvim").matchSkipCursor(-1) end, mode = { "n", "x" }, desc = "Multicursor: skip prev match" },

      -- Add all matches in the document.
      { "<leader>A", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "x" }, desc = "Multicursor: add all matches" },

      -- Mouse support: add/toggle cursor with ctrl + left click.
      { "<C-leftmouse>", function() require("multicursor-nvim").handleMouse() end, mode = "n", desc = "Multicursor: mouse add cursor" },
      { "<C-leftdrag>", function() require("multicursor-nvim").handleMouseDrag() end, mode = "n", desc = "Multicursor: mouse drag" },
      { "<C-leftrelease>", function() require("multicursor-nvim").handleMouseRelease() end, mode = "n", desc = "Multicursor: mouse release" },

      -- Rotate which cursor is the "main" one.
      { "<left>", function() require("multicursor-nvim").prevCursor() end, mode = { "n", "x" }, desc = "Multicursor: prev cursor" },
      { "<right>", function() require("multicursor-nvim").nextCursor() end, mode = { "n", "x" }, desc = "Multicursor: next cursor" },

      -- Delete the main cursor.
      { "<leader>X", function() require("multicursor-nvim").deleteCursor() end, mode = { "n", "x" }, desc = "Multicursor: delete main cursor" },

      -- Toggle cursors active/disabled, or align them.
      { "<C-q>", function() require("multicursor-nvim").toggleCursor() end, mode = { "n", "x" }, desc = "Multicursor: toggle cursor" },
      { "<leader><C-q>", function() require("multicursor-nvim").alignCursors() end, mode = { "n", "x" }, desc = "Multicursor: align cursors" },

      -- Split / match within a visual selection.
      { "S", function() require("multicursor-nvim").splitCursors() end, mode = "x", desc = "Multicursor: split selection into cursors" },
      { "I", function() require("multicursor-nvim").insertVisual() end, mode = "x", desc = "Multicursor: insert at start of selection" },
      { "A", function() require("multicursor-nvim").appendVisual() end, mode = "x", desc = "Multicursor: append at end of selection" },
      { "M", function() require("multicursor-nvim").matchCursors() end, mode = "x", desc = "Multicursor: match pattern in selection" },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- <esc>: clear cursors if active, otherwise normal <esc> behaviour.
      vim.keymap.set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          vim.cmd("nohlsearch")
        end
      end, { desc = "Multicursor: clear cursors / nohlsearch" })

      -- Customise cursor highlights to match the colorscheme's visual group.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
