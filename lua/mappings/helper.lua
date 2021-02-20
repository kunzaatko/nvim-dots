function string:is_cmd(options)
    local lua = options.lua and "lua " or ""
    -- cmd-mapping has to be concluded with a <CR> and I want to display <Cmd> instead of :
    local method = options.no_cr and {cmd = ":", cr = ""} or {cmd = "<Cmd>", cr = "<CR>"}

    return  method.cmd..lua..self..method.cr
end

