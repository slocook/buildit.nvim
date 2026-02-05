local M = {}

local output = require('buildit.output')
local config = require('buildit.config').options.ninja

function M.configure()
    -- no-op: ninja doesn't have a configure step
end

function M.build()
    output.run_cmd('ninja -C ' .. config.build_dir .. ' -j ' .. config.threads)
end

function M.clean()
    output.run_cmd('ninja -C ' .. config.build_dir .. ' clean')
end

function M.test()
    output.run_cmd('ninja -C ' .. config.build_dir .. ' test')
end

return M
