local M = {}

local output = require('buildit.output')
local config = require('buildit.config').options.autotools

function M.configure()
    output.run_cmd('./configure')
end

function M.build()
    output.run_cmd('make -j ' .. config.threads)
end

function M.clean()
    output.run_cmd('make clean')
end

function M.test()
    output.run_cmd('make check')
end

return M
