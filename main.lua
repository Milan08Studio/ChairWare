local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport
if queueonteleport then queueonteleport(game:HttpGet("https://raw.githubusercontent.com/Milan08Studio/ChairWare/main/main.lua")) end
local games = {
    [4580204640] = "SurviveTheKiller",
    [7863262550] = "FOBLOX"
}
local currentGame = games[game.PlaceId]
if currentGame then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Milan08Studio/ChairWare/main/Games/"..currentGame..".lua"))()
end
