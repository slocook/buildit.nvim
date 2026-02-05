local M = {}

M.system = nil       -- detected build system name
M.status = 'idle'    -- 'idle' | 'running' | 'success' | 'failed'
M.exit_code = nil    -- last exit code

function M.set_running(system_name)
    M.system = system_name
    M.status = 'running'
    M.exit_code = nil
end

function M.set_finished(exit_code)
    M.exit_code = exit_code
    if exit_code == 0 then
        M.status = 'success'
    else
        M.status = 'failed'
    end
end

function M.format()
    if not M.system then
        return ''
    end

    local icon
    if M.status == 'running' then
        icon = '...'
    elseif M.status == 'success' then
        icon = '✓'
    elseif M.status == 'failed' then
        icon = '✗'
    else
        icon = '-'
    end

    local str = '[buildit: ' .. M.system .. '] ' .. icon
    if M.status == 'failed' and M.exit_code then
        str = str .. ' (' .. M.exit_code .. ')'
    end

    return str
end

return M
