local M = {}

local output = require('buildit.output')
local config = require('buildit.config').options.ninja

function M.configure()
    -- no-op: ninja doesn't have a configure step
end

function M.build(root)
    output.run_cmd('ninja -C ' .. config.build_dir .. ' -j ' .. config.threads, root)
end

function M.clean(root)
    output.run_cmd('ninja -C ' .. config.build_dir .. ' clean', root)
end

function M.test(root)
    output.run_cmd('ninja -C ' .. config.build_dir .. ' test', root)
end

return M
