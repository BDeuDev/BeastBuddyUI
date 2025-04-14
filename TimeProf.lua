local function ProfileTime(label, fn)
    local start = debugprofilestop()

    if type(fn) == "function" then
        fn()
    end

    local finish = debugprofilestop()
    local duration_ms = finish - start
    local duration_s = duration_ms / 1000

    DEFAULT_CHAT_FRAME:AddMessage(
        string.format("|cff00ff00[%s]:|r %.3f ms (%.3f s)", label or "Sin etiqueta", duration_ms, duration_s)
    )
end

SLASH_TIMEPROF1 = "/timeprof"
SlashCmdList["TIMEPROF"] = function()
    ProfileTime("Prueba de tiempo", function()
        local t = {}
        for i = 1, 5000 do
            t[i] = "valor" .. i
        end
    end)
end

