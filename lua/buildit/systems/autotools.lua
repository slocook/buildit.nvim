local M = {}

local output = require('buildit.output')
local config = require('buildit.config').options.autotools

function M.configure(root)
    output.run_cmd('./configure', root)
end

function M.build(root)
    output.run_cmd('make -j ' .. config.threads, root)
end

function M.clean(root)
    output.run_cmd('make clean', root)
end

function M.test(root)
    output.run_cmd('make check', root)
end

return M
