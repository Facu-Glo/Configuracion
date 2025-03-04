return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    local wk = require("which-key")
    wk.add({
      { "<leader>m", name = "Multicursores", icon = "󰇀" },
    })

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({ "n", "x" }, "<leader>mu", function()
      mc.lineAddCursor(-1)
    end, { desc = "Añadir cursor arriba" })
    set({ "n", "x" }, "<leader>md", function()
      mc.lineAddCursor(1)
    end, { desc = "Añadir cursor abajo" })
    set({ "n", "x" }, "<leader>m<up>", function()
      mc.lineSkipCursor(-1)
    end, { desc = "Salta una línea hacia arriba sin agregar un cursor." })
    set({ "n", "x" }, "<leader>m<down>", function()
      mc.lineSkipCursor(1)
    end, { desc = "Salta una línea hacia abajo sin agregar un cursor." })
    --
    -- -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<leader>mn", function()
      mc.matchAddCursor(1)
    end, { desc = "Agregar cursor en la siguiente coincidencia" })
    set({ "n", "x" }, "<leader>ms", function()
      mc.matchSkipCursor(1)
    end, { desc = "Saltar una coincidencia y agregar cursor en la siguiente" })
    set({ "n", "x" }, "<leader>mN", function()
      mc.matchAddCursor(-1)
    end, { desc = "Agregar cursor en la coincidencia anterior" })
    set({ "n", "x" }, "<leader>mS", function()
      mc.matchSkipCursor(-1)
    end, { desc = "Saltar una coincidencia y agregar cursor en la anterior" })

    -- In normal/visual mode, press `mwap` will create a cursor in every match of
    -- the word captured by `iw` (or visually selected range) inside the bigger
    -- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
    set({ "n", "x" }, "mw", function()
      mc.operator({ motion = "iw", visual = true })
      -- Or you can pass a pattern, press `mwi{` will select every \w,
      -- basically every char in a `{ a, b, c, d }`.
      -- mc.operator({ pattern = [[\<\w]] })
    end)

    -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
    set("n", "mW", mc.operator)

    -- Add all matches in the document
    set({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "Añadir cursores a todas las coincidencias" })

    -- You can also add cursors with any motion you prefer:
    -- set("n", "<right>", function()
    --     mc.addCursor("w")
    -- end)
    -- set("n", "<leader><right>", function()
    --     mc.skipCursor("w")
    -- end)

    -- Rotate the main cursor.
    set({ "n", "x" }, "<left>", mc.nextCursor)
    set({ "n", "x" }, "<right>", mc.prevCursor)

    -- Delete the main cursor.
    set({ "n", "x" }, "<leader>mx", mc.deleteCursor, { desc = "Eliminar cursor" })

    -- Add and remove cursors with control + left click.
    set("n", "<c-leftmouse>", mc.handleMouse)
    set("n", "<c-leftdrag>", mc.handleMouseDrag)
    set("n", "<c-leftrelease>", mc.handleMouseRelease)
    set({ "n", "x" }, "<leader>mq", mc.clearCursors, { desc = "Eliminar todos los cursores" })

    -- -- Easy way to add and remove cursors using the main cursor.
    set({ "n", "x" }, "<leader>ma", mc.toggleCursor, { desc = "Agregar cursor" })
    --
    -- -- Clone every cursor and disable the originals.
    set({ "n", "x" }, "<leader>m<c-q>", mc.duplicateCursors, { desc = "Clonar cursores y deshabilitar originales" })

    -- set("n", "<esc>", function()
    --   if not mc.cursorsEnabled() then
    --     mc.enableCursors()
    --   elseif mc.hasCursors() then
    --     mc.clearCursors()
    --   else
    --     -- Default <esc> handler.
    --   end
    -- end)

    -- -- bring back cursors if you accidentally clear them
    -- set("n", "<leader>gv", mc.restoreCursors)
    --
    -- -- Align cursor columns.
    set("n", "<leader>mc", mc.alignCursors, { desc = "Alinear en columnas" })
    --
    -- -- Split visual selections by regex.
    set("x", "S", mc.splitCursors)
    --
    -- -- Append/insert for each line of visual selections.
    set("x", "I", mc.insertVisual)
    set("x", "A", mc.appendVisual)
    --
    -- -- match new cursors within visual selections by regex.
    set("x", "M", mc.matchCursors)
    --
    -- -- Rotate visual selection contents.
    set("x", "<leader>t", function()
      mc.transposeCursors(1)
    end)
    set("x", "<leader>T", function()
      mc.transposeCursors(-1)
    end)
    --
    -- -- Jumplist support
    set({ "x", "n" }, "<c-i>", mc.jumpForward)
    set({ "x", "n" }, "<c-o>", mc.jumpBackward)
    --

    set("n", "<leader>me", mc.enableCursors, { desc = "Activar los cursores" })

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
