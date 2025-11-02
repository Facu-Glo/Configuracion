local M = {}

function M.getDirectoryName(path)
    if not path then return "Unknown" end
    path = path:gsub("/+$", "")
    return path:match("([^/]+)$") or "Unknown"
end

return M
