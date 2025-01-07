local M = {}

local function parse_line(line)
    local key, val = line:match("^%s*([%w_]+)%s*=%s*(.*)%s*$")
    if not key or not val then return nil, nil end
    val = val:gsub('^["\'](.-)["\']$', '%1')
    return key, val
end

local function load_env_file(filepath)
    local env_vars = {}
    local file = io.open(filepath, 'r')
    if not file then return env_vars end
    for line in file:lines() do
        local k, v = parse_line(line)
        if k and v then
            env_vars[k] = v
        end
    end
    file:close()
    return env_vars
end

local function merge_envs(base_env, override_env)
    for k, v in pairs(override_env) do
        base_env[k] = v
    end
end

function M.setup(opts)
    opts = opts or {}
    local config_dir = vim.fn.stdpath('config')
    local config_files = opts.config_overrides or { '.env' }
    local cwd_files = opts.overrides or { '.env' }

    local final_env = {}

    -- load env from nvim config
    for _, file in ipairs(config_files) do
        local env_vars = load_env_file(config_dir .. '/' .. file)
        merge_envs(final_env, env_vars)
    end

    -- now override from cwd
    local cwd = vim.loop.cwd()
    for _, file in ipairs(cwd_files) do
        local env_vars = load_env_file(cwd .. '/' .. file)
        merge_envs(final_env, env_vars)
    end

    -- apply final env
    for k, v in pairs(final_env) do
        vim.fn.setenv(k, v)
    end
end

return M
