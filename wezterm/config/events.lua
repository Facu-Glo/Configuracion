local M = {}

function M.setup_status(wezterm)
  wezterm.on('update-right-status', function(window)
      local mode = window:active_key_table()
      window:set_right_status(mode and ('MODE: ' .. mode) or '')
  end)
end

return M
