local cringediscord = 'WNeMvS5GB4'
local text = Instance.new("TextLabel",Instance.new("ScreenGui",game.CoreGui))
text.Text = "ChairWare is currently broken due to a game update!\nWe're updating very soon, join the discord in the meantime!\ndiscord.gg/"..cringediscord
text.Position = UDim2.new(0,0,0,0)
text.Size = UDim2.new(1,1,1,1)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.new(1.0, 1.0, 1.0)
text.TextSize = 20
if syn then
    syn.request({
    Url = "http://127.0.0.1:6463/rpc?v=1",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json",
        ["Origin"] = "https://discord.com"
    },
    Body = game:GetService("HttpService"):JSONEncode({
        cmd = "INVITE_BROWSER",
        args = {
            code = cringediscord
        },
        nonce = game:GetService("HttpService"):GenerateGUID(false)
    }),
    })
else
    setclipboard("discord.gg/"..cringediscord)
    game.StarterGui:SetCore("SendNotification",{Title="Discord",Text="Copied invite to clipboard, please join!"})
end
return
