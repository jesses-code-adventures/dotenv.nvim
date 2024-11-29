local M = {}

local function parse_line(line)
    local key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)%s*$")
    if not key or not value then return nil, nil end
    value = value:gsub('^["\'](.-)["\']$', "%1")
    return key, value
end

local function load_env_file(filepath)
    local env_vars = {}
    local file = io.open(filepath, "r")
    if not file then return env_vars end

    for line in file:lines() do
        local key, value = parse_line(line)
        if key and value then
            env_vars[key] = value
        end
    end
    file:close()
    return env_vars
end

local function merge_envs(base_env, override_env)
    for key, value in pairs(override_env) do
        base_env[key] = value
    end
end

function M.setup(opts)
    local cwd = vim.loop.cwd()
    local env_files = opts.overrides or { ".env" }
    local final_env = {}
    for _, file in ipairs(env_files) do
        local filepath = cwd .. "/" .. file
        local env_vars = load_env_file(filepath)
        merge_envs(final_env, env_vars)
    end
    for key, value in pairs(final_env) do
        vim.fn.setenv(key, value)
    end
end

return M
