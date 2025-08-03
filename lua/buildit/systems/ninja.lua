local M = {}

local output = require('buildit.output')
local build_dir = 'build'

function M.configure()
    -- no-op
end

function M.build()
    output.run_cmd('ninja -C ' .. build_dir)
end

function M.clean()
    output.run_cmd('ninja -C ' .. build_dir .. ' clean')
end

return M
