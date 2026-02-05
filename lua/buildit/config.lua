local M = {}

M.options = {
    cmake = {
        build_dir = 'build',
        build_type = 'Debug',
        threads = 4
    },
    ninja = {
        build_dir = 'build',
        threads = 4
    }
}

function M.setup(user_opts)
    user_opts = user_opts or {}
    M.options.cmake = vim.tbl_deep_extend('force', M.options.cmake, user_opts.cmake or {})
    M.options.ninja = vim.tbl_deep_extend('force', M.options.ninja, user_opts.ninja or {})
end

return M
