local output = require('buildit.output')
local config = require('buildit.config').options.cmake

local function escape(s)
    return vim.fn.shellescape(s)
end

local function build_dir()
    return escape(config.build_dir)
end

local function configure_cmd()
    local args = {
        '-S .',
        '-B ' .. build_dir(),
        '-DCMAKE_BUILD_TYPE=' .. escape(config.build_type)
    }
    return 'cmake ' .. table.concat(args, ' ')
end

local function build_cmd()
    local args = {
        '--build ' .. build_dir(),
        '-j ' .. config.threads
    }
    return 'cmake ' .. table.concat(args, ' ')
end

local function clean_cmd()
    return 'cmake --build ' .. build_dir() .. ' --target clean'
end

return {
    configure = function(root) output.run_cmd(configure_cmd(), root) end,
    build = function(root) output.run_cmd(build_cmd(), root) end,
    clean = function(root) output.run_cmd(clean_cmd(), root) end,
    test = function(root) output.run_cmd('ctest', root .. '/' .. config.build_dir) end
}
