-- ImportURL

-- Usage: importURL([tabname,] url)
function importURL(tabname, url)
    tabname, url = url and tabname, url or tabname

    if not tabname then
        tabname = url:sub(#url - url:reverse():find("/", 1) + 2, #url)
        tabname = tabname:sub(1, tabname:find("%.", 1) - 1)
    end

    http.request(url, function(data, status, headers)
        if status == 200 then
            saveProjectTab(tabname, data)
            print("Tab '"..tabname.."' created")
        else
            print("Failed to download '"..url.."' to '"..tabname.."'")
        end
    end)
end