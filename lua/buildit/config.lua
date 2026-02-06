local M = {}

M.options = {
    projects = {},
    cmake = {
        build_dir = 'build',
        build_type = 'Debug',
        threads = 4
    },
    ninja = {
        build_dir = 'build',
        threads = 4
    },
    autotools = {
        threads = 4
    }
}

function M.setup(user_opts)
    user_opts = user_opts or {}
    M.options.projects = vim.tbl_deep_extend('force', M.options.projects, user_opts.projects or {})
    M.options.cmake = vim.tbl_deep_extend('force', M.options.cmake, user_opts.cmake or {})
    M.options.ninja = vim.tbl_deep_extend('force', M.options.ninja, user_opts.ninja or {})
    M.options.autotools = vim.tbl_deep_extend('force', M.options.autotools, user_opts.autotools or {})
end

return M
