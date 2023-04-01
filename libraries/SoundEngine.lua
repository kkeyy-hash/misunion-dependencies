return {
    playCustomSound = function(asset, settings)
        local asset = getsynasset("NordHook/Sounds/" .. asset)
        if not asset then return end
        local Sound = Instance.new("Sound", workspace)
        Sound.SoundId = asset
        table.foreach(settings, function(I, V)
            Sound[I] = V
        end)
        Sound:Play()
        Sound.Ended:Connect(function()
            Sound:Remove()
        end)
    end,
    replaceSound = function(sound, asset)
        if typeof(sound) ~= "Instance" or not sound:IsA("Sound") then return end
        sound.SoundId = getsynasset("NordHook/Sounds/" .. asset) or sound.SoundId
    end,
    replaceSoundIdGlobally = function(soundId, asset, customCheck)
        local Replaced = {}
        local customCheck = type(customCheck) == "function" and customCheck or nil

        for _, Object in next, game:GetDescendants() do
            if Object:IsA("Sound") then
                if customCheck then customCheck() end
                if Object.SoundId == soundId or Object.SoundId:find(soundId) then
                    Replaced[Object] = Object.SoundId
                    Object.SoundId = getsynasset(asset) or Object.SoundId
                end
            end
        end
        
        local Connection; Connection = game.DescendantAdded:Connect(function(Object)
            if Object:IsA("Sound") then
                if customCheck then customCheck() end
                if Object.SoundId == soundId or Object.SoundId:find(soundId) then
                    Replaced[Object] = Object.SoundId
                    Object.SoundId = getsynasset("NordHook/Sounds/" .. asset) or Object.SoundId
                end
            end
        end)
    end
}