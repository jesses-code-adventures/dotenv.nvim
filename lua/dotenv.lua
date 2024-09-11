local M = {}

local function split_first(s, delimiter)
    local delimiter_pos = string.find(s, delimiter, 1, true)
    if not delimiter_pos then
        return s
    end
    local key = string.sub(s, 1, delimiter_pos - 1)
    local value = string.sub(s, delimiter_pos + 1)
    return key, value
end

local function parse_value(value)
    value = value:match("^%s*(.-)%s*$")
    if (value:sub(1, 1) == '"' and value:sub(-1) == '"') or
       (value:sub(1, 1) == "'" and value:sub(-1) == "'") then
        value = value:sub(2, -2)
    end
    return value
end


function M.setup(opts)
    local env_file = opts and opts.env_path and vim.fn.expand(opts.env_path) or vim.fn.stdpath("config") .. "/.env"
    local file = io.open(env_file, "r")
    if not file then
      error("Couldn't locate a .env file in your nvim config when searching: " .. env_file)
    end
    for line in file:lines() do
        if line == "" or line == nil or line:match("^%s*#") then
            goto continue
        end
        local parts = {split_first(line, "=")}
        if #parts < 2 then
            error("Incorrectly formatted line in .env file: " .. line)
        end
        local key, value = split_first(line, "=")
        if not value then
            error("Value is nil for line: " .. line)
        end
        value = parse_value(value)
        vim.fn.setenv(key, value)
        ::continue::
    end
    file:close()
end

return M
