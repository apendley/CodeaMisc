-- ImportURL

function importURL(...)
    assert( #arg == 1 or #arg == 2, "Usage: importURL([tabname,] url)" )    
    
    local url, tabname
    
    if #arg == 1 then
        url = arg[1]
    elseif #arg == 2 then
        tabname = arg[1]
        url = arg[2]
    end
    
    if not tabname then
        tabname = url
        local n = #tabname - tabname:reverse():find("/", 1) + 1
        tabname = tabname:sub(n+1, #tabname)
        tabname = tabname:sub(1, tabname:find("%.", 1) - 1)
    end

    local callback = function(data, status, headers)
        if status == 200 then
            saveProjectTab(tabname, data)
            print("Tab '"..tabname.."' created")
        else
            print("Failed to download '"..url.."'")
        end
    end
    
    http.request(url, callback)    
end
