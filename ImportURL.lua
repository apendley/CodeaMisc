-- ImportURL

function importURL(...)
    assert( #arg == 1 or #arg == 2, "Usage: importURL([tabname,] url)" )

    local url, tabname = arg[2] or arg[1], arg[2] and arg[1]

    if not tabname then
        tabname = url:sub(#url - url:reverse():find("/", 1) + 2, #url)
        tabname = tabname:sub(1, tabname:find("%.", 1) - 1)
    end

    http.request(url, function(data, status, headers)
        if status == 200 then
            saveProjectTab(tabname, data)
            print("Tab '"..tabname.."' created")
        else
            print("Failed to download '"..url.."'")
        end
    end)
end