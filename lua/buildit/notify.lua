local M = {}

local function notify(msg, level)
    vim.notify('[buildit] ' .. msg, level)
end

function M.error(msg)
    notify(msg, vim.log.levels.ERROR)
end

function M.warn(msg)
    notify(msg, vim.log.levels.WARN)
end

function M.info(msg)
    notify(msg, vim.log.levels.INFO)
end

return M
