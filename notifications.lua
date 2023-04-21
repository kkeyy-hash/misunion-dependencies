--> Variables <--
local Library = {
    zIndex = 1400,
    notifications = {}
}
local Utility = {}
local newUDim2 = UDim2.new
local Gradient = game:HttpGet("https://raw.githubusercontent.com/portallol/luna/main/modules/gradient90.png")
local Signal = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/kkeyy-hash/nordhook/main/signal.lua"))()

--> Utility <--
do
    function Utility:UDim2ToVector2(udim2, vector2)
        local x, y
        x = udim2.X.Offset + (((udim2.X.Scale - 0) * (vector2.X - 0)) / (1 - 0)) + 0
        y = udim2.Y.Offset + (((udim2.Y.Scale - 0) * (vector2.Y - 0)) / (1 - 0)) + 0
        return Vector2.new(x, y)
    end
    function Utility:Tween(Object, Property, Value, Time, Direction, Style)
        local HasProperty =
            pcall(
            function()
                local Property = Object[Property]
            end
        )
        if HasProperty then
            if Tweens[Object] then
                if Tweens[Object][Property] then
                    Tweens[Object][Property]:Cancel()
                end
            end

            local StartValue = Object[Property]
            local a = 0
            local Tween = {
                Completed = Signal.new()
            }

            Tweens[Object] = Tweens[Object] or {}
            Tweens[Object][Property] = Tween

            Tween.Connection =
                game:GetService("RunService").RenderStepped:Connect(
                function(DeltaTime)
                    a = a + (DeltaTime / Time)
                    if a >= 1 or Object == nil then
                        Tween:Cancel()
                    end
                    pcall(
                        function()
                            local Progress =
                                game:GetService("TweenService"):GetValue(
                                a,
                                Style or Enum.EasingStyle.Linear,
                                Direction or Enum.EasingDirection.In
                            )
                            local NewValue
                            if typeof(StartValue) == "number" then
                                NewValue = StartValue + (Value - StartValue) * Progress
                            else
                                NewValue = StartValue:Lerp(Value, Progress)
                            end
                            Object[Property] = NewValue
                        end
                    )
                end
            )

            function Tween:Cancel()
                Tween.Connection:Disconnect()
                Tween.Completed:Fire()
                table.clear(Tween)
                Tweens[Object][Property] = nil
            end

            return Tween
        end
    end
end

function Library:SendNotification(message, time, color)
    time = time or 5
    if typeof(message) ~= "string" then
        return error(string.format("invalid message type, got %s, expected string", typeof(message)))
    elseif typeof(time) ~= "number" then
        return error(string.format("invalid time type, got %s, expected number", typeof(time)))
    elseif color ~= nil and typeof(color) ~= "Color3" then
        return error(string.format("invalid color type, got %s, expected color3", typeof(time)))
    end

    local notification = {}

    self.notifications[notification] = true

    do
        local objs = notification
        local z = self.zIndex

        notification.holder =
            utility:Draw(
            "Square",
            {
                Position = newUDim2(0, 0, 0, 75),
                Transparency = 0
            }
        )

        notification.background =
            utility:Draw(
            "Square",
            {
                Size = newUDim2(1, 0, 1, 0),
                Position = newUDim2(0, -500, 0, 0),
                Parent = notification.holder,
                ThemeColor = "Background",
                ZIndex = z
            }
        )

        notification.border1 =
            utility:Draw(
            "Square",
            {
                Size = newUDim2(1, 2, 1, 2),
                Position = newUDim2(0, -1, 0, -1),
                ThemeColor = "Border 2",
                Parent = notification.background,
                ZIndex = z - 1
            }
        )

        objs.border2 =
            utility:Draw(
            "Square",
            {
                Size = newUDim2(1, 2, 1, 2),
                Position = newUDim2(0, -1, 0, -1),
                ThemeColor = "Border 3",
                Parent = objs.border1,
                ZIndex = z - 2
            }
        )

        notification.gradient =
            utility:Draw(
            "Image",
            {
                Size = newUDim2(1, 0, 1, 0),
                Data = self.images.gradientp90,
                Parent = notification.background,
                Transparency = .5,
                ZIndex = z + 1
            }
        )

        notification.accentBar =
            utility:Draw(
            "Square",
            {
                Size = newUDim2(0, 5, 1, 4),
                Position = newUDim2(0, 0, 0, -2),
                Parent = notification.background,
                ThemeColor = color == nil and Color3.,
                ZIndex = z + 5
            }
        )

        notification.text =
            utility:Draw(
            "Text",
            {
                Position = newUDim2(0, 13, 0, 2),
                ThemeColor = "Primary Text",
                Text = message,
                Outline = true,
                Font = 2,
                Size = 13,
                ZIndex = z + 4,
                Parent = notification.background
            }
        )

        if color then
            notification.accentBar.Color = color
        end
    end

    function notification:Remove()
        Library.notifications[notification] = nil
        self.holder:Remove()
        Library:UpdateNotifications()
    end

    task.spawn(
        function()
            self:UpdateNotifications()
            notification.background.Size = newUDim2(0, notification.text.TextBounds.X + 20, 0, 19)
            task.wait()
            utility:Tween(notification.background, "Position", newUDim2(0, 0, 0, 0), .1)
            task.wait(time)
            for i, v in next, notification do
                if typeof(v) ~= "function" then
                    utility:Tween(v, "Transparency", 0, .15)
                end
            end
            utility:Connection(
                utility:Tween(notification.background, "Position", newUDim2(0, -500, 0, 0), .25).Completed,
                (function()
                    notification:Remove()
                end)
            )
        end
    )
end

function Utility:UpdateNotifications()
    local i = 0
    for v in next, self.notifications do
        utility:Tween(v.holder, "Position", newUDim2(0, 0, 0, 75 + (i * 30)), .15)
        i = i + 1
    end
end
