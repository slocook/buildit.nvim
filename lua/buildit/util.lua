local M = {}

function M.executable(cmd)
    return vim.fn.executable(cmd) == 1
end

return M
