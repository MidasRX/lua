--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
repeat task.wait() until game:IsLoaded()

if game.PlaceId == 5041144419 then
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    
    local gameId = game.PlaceId
    local localPlayer = Players.LocalPlayer

    local function serverHop()
        local serversUrl = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100"
        local serversData = HttpService:JSONDecode(game:HttpGet(serversUrl))

        for _, server in ipairs(serversData.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(gameId, server.id, localPlayer)
                break
            end
        end
    end

    local screenGui = Instance.new("ScreenGui")
    local textLabel = Instance.new("TextLabel")

    screenGui.Parent = game:GetService("CoreGui")

    textLabel.Parent = screenGui
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1.000
    textLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.BorderSizePixel = 0
    textLabel.Position = UDim2.new(0.212657391, 0, 0.0501222499, 0)
    textLabel.Size = UDim2.new(0, 1074, 0, 50)
    textLabel.Font = Enum.Font.SourceSans
    textLabel.Text = "Last Reported Player: 'None' for 'nothing'"
    textLabel.TextColor3 = Color3.fromRGB(255, 105, 105)
    textLabel.TextScaled = true
    textLabel.TextSize = 14.000
    textLabel.TextWrapped = true

    local reportTypes = {
        {0, "Harassment"},
        {1, "Announcement Abuse"},
        {2, "Radio Spam"},
        {3, "Breaching"},
        {4, "Exploiting"}
    }

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            for _, report in ipairs(reportTypes) do
                local args = {
                    [1] = report[1],
                    [2] = player.Name
                }

                ReplicatedStorage.Remotes.Report:InvokeServer(unpack(args))

                textLabel.Text = "Last Reported Player: '" .. player.Name .. "' for '" .. report[2] .. "'."
            end
        end
    end
end