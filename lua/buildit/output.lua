local M = {}

local notify = require('buildit.notify')

local buf, win = nil, nil
local last_title = nil
local project_cwd = nil

local function jump_to_error()
    local line = vim.api.nvim_get_current_line()

    local patterns = {
        '([^%s:]+):(%d+):(%d+)',      -- file:line:col (gcc, clang, rust, go)
        '([^%s:]+):(%d+)',             -- file:line
        '([^%s%(]+)%((%d+),(%d+)%)',   -- file(line,col) (msvc)
        '([^%s%(]+)%((%d+)%)',         -- file(line) (msvc)
    }

    for _, pattern in ipairs(patterns) do
        local file, lnum, col = line:match(pattern)
        if file and lnum then
            lnum = tonumber(lnum)
            col = tonumber(col) or 1

            if project_cwd and not file:match('^/') then
                file = project_cwd .. '/' .. file
            end

            if vim.fn.filereadable(file) == 1 then
                M.close()
                vim.cmd('edit ' .. vim.fn.fnameescape(file))
                vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })
                return
            end
        end
    end

    M.close()
end

function M.is_open()
    return win and vim.api.nvim_win_is_valid(win)
end

function M.close()
    if M.is_open() then
        vim.api.nvim_win_close(win, true)
        win = nil
    end
end

function M.toggle()
    if M.is_open() then
        M.close()
    else
        M.open(last_title)
    end
end

function M.open(title)
    if title then
        last_title = title
    end

    if M.is_open() then
        vim.api.nvim_set_current_win(win)
        return buf, win
    end

    buf = buf or vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        row = row,
        col = col,
        width = width,
        height = height,
        style = 'minimal',
        border = 'rounded',
        title = last_title
    })

    vim.keymap.set('n', '<CR>', jump_to_error, { buffer = buf, noremap = true, silent = true })
    vim.keymap.set('n', 'q', M.close, { buffer = buf, noremap = true, silent = true })
    vim.keymap.set('n', '<Esc>', M.close, { buffer = buf, noremap = true, silent = true })
    vim.keymap.set('n', '<C-c>', M.close, { buffer = buf, noremap = true, silent = true })

    return buf, win
end

local function append_to_buffer(lines)
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return
    end

    vim.schedule(function()
        if not buf or not vim.api.nvim_buf_is_valid(buf) then
            return
        end

        vim.api.nvim_buf_set_option(buf, 'modifiable', true)
        local line_count = vim.api.nvim_buf_line_count(buf)

        local filtered = {}
        for _, line in ipairs(lines) do
            if line ~= '' then
                table.insert(filtered, line)
            end
        end

        if #filtered > 0 then
            vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, filtered)

            if M.is_open() then
                local new_count = vim.api.nvim_buf_line_count(buf)
                vim.api.nvim_win_set_cursor(win, { new_count, 0 })
            end
        end

        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    end)
end

function M.run_cmd(cmd, cwd)
    buf = nil
    M.close()

    buf, win = M.open(cmd)
    cwd = cwd or vim.fn.getcwd()
    project_cwd = cwd

    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

    local function on_output(_, data, _)
        if data then
            append_to_buffer(data)
        end
    end

    local job_id = vim.fn.jobstart(cmd, {
        cwd = cwd,
        stdout_buffered = false,
        stderr_buffered = false,
        on_stdout = on_output,
        on_stderr = on_output,
        on_exit = function(_, exit_code)
            vim.schedule(function()
                if exit_code == 0 then
                    notify.info('Command completed successfully')
                else
                    notify.error('Command failed with exit code ' .. exit_code)
                end
            end)
        end
    })

    if job_id == 0 then
        notify.error('Invalid arguments to jobstart')
    elseif job_id == -1 then
        notify.error('Command not executable: ' .. cmd)
    end
end

return M
