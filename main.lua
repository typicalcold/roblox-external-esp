print("finding")
local TargetPartName = "Head"
local DrawTeammates = true
local FindHumanoids = false
local path = "drawingdata/data.json"
local Camera = workspace.CurrentCamera

while true do
    local Targets = {}
    for _, Player in pairs(game.Players:GetPlayers()) do
        if Player == game.Players.LocalPlayer then
            continue
        end
        local IsTeammate = game.Players.LocalPlayer.Team and Player.Team == game.Players.LocalPlayer.Team
        if not DrawTeammates and IsTeammate then
            continue
        end
        local Character = Player.Character
        if not Character then
            continue
        end
        local TargetPart = Character:FindFirstChild(TargetPartName)
        if not TargetPart then
            continue
        end
        local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(TargetPart.Position)
        if OnScreen then
            table.insert(Targets, {Vector2.new(ScreenPoint.X, ScreenPoint.Y), tostring(TargetPart.Parent.Name)})
        end
    end

    local cached = "["
    local first = true
    for _, Target in pairs(Targets) do
        if not first then
            cached = cached .. ","
        end
        cached = cached .. '{"X":' .. tostring(Target[1].X) .. ', "Y":' .. tostring(Target[1].Y) .. ', "name":"' .. Target[2] .. '", "Distance": 10}'
        first = false
    end
    cached = cached .. "]"
    
    writefile(path, cached)
    --task.spawn(writefile, path, HttpService:JSONEncode(Targets)) --task.spawn is buggy
    task.wait() 
end

warn("Exited") -- This line will only execute if the script exits the while loop, not normally during execution
