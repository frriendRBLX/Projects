local DS2Wrapper = {}

--[[
    DataStore2 Wrapper by frriend

    Allows automatic saving, validation, and updating of Values within a folder!

    Usage:
        + DS:Register(DEFAULT_FOLDER, PLAYER_FOLDER, PLAYER)

--]]

local DS2 = require(game.ReplicatedStorage.DataStore2) -- Path to Datastore 2 
DS2.Combine("PlayerData", "Data")

function DS2Wrapper:Register(DefaultDataFolder, PlayerDataFolder, Player)
    task.spawn(function()
        -- Create DataStore for Player --
        local PlayerDataStore = DS2("Data", Player)

        -- Create a Default Dictionary to Compare To --
        local DefaultData = {}
        for _, item in ipairs(DefaultDataFolder:GetDescendants()) do
            DefaultData[tostring(item.Name)] = item.Value
        end

        -- Get Player Data | If it doesn't exist, set it to the defaults --
        local PlayerData = PlayerDataStore:Get(DefaultData)

        -- Verify Player Data --
        for key, value in pairs(DefaultData) do
            if PlayerData[key] == nil then
                PlayerData[key] = value          
            end
        end

        -- Remove Depricated Data --
        for key, _ in pairs(PlayerData) do
            if DefaultData[key] == nil then
                PlayerData[key] = nil
            end
        end
        
        -- Update/Listen to Player Cache --
		for _, valueObject in ipairs(PlayerDataFolder:GetDescendants()) do
            valueObject.Value = PlayerData[valueObject.Name]

            valueObject.Changed:Connect(function(value)
                PlayerData[valueObject.Name] = value
                PlayerDataStore:Set(PlayerData)
            end)
        end
    end)    
end

return DS2Wrapper
