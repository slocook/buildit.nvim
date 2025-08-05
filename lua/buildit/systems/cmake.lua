local output = require('buildit.output')
local config = require('buildit.config').options.cmake

local function escape(s)
    return vim.fn.shellescape(s)
end

local function build_dir()
    return escape(config.build_dir)
end

local function configure()
    local args = {
        '-S .',
        '-B ' .. build_dir(),
        '-DCMAKE_BUILD_TYPE=' .. escape(config.build_type)
    }
    return 'cmake ' .. table.concat(args, ' ')
end

local function build()
    local args = {
        '--build ' .. build_dir(),
        '-j ' .. escape(config.threads)
    }
    return 'cmake ' .. table.concat(args, ' ')
end

local function clean()
    local args = {
        '--build ' .. build_dir(),
        '--target clean'
    }
    return 'cmake ' .. table.concat(args, ' ')
end

return {
    configure = function() output.run_cmd(configure()) end,
    build = function() output.run_cmd(build()) end,
    clean = function() output.run_cmd('cmake --build ' .. build_dir() .. ' --target clean') end,
    test = function() output.run_cmd('ctest', 'build') end
}
