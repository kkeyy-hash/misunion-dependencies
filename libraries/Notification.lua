local module = {
    accent = Color3.fromRGB(0, 100, 255),
    
    x = workspace.CurrentCamera.ViewportSize.X - 1,
    y = workspace.CurrentCamera.ViewportSize.Y - 1
}

function module:tween(obj, properties)
    local c_time = 0
    local m_time = properties.Duration
    
    local s_size = properties.Start
    local e_size = properties.End
    
    local conn
    
    conn = game:GetService('RunService').RenderStepped:Connect(function(delta)
        pcall(function()
            c_time += delta
            obj.Size = s_size:Lerp(e_size, game.TweenService:GetValue(c_time / m_time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))
            if c_time > m_time then
                if properties.Callback then properties.Callback() end
                
                conn:Disconnect()
                conn = nil
            end
        end)
    end)
end
function module:create(name, properties)
    local d = nil
    
    if name == 'Frame' or name == 'frame' then 
        d = Drawing.new('Square')
        d.Thickness = 0 
    end
    if name == 'Text' or name == 'text' then
        d = Drawing.new('Text')
        d.Center = true 
        d.Font = 3
    end
    
    for i,v in pairs(properties) do
        d[i] = v
    end
    
    return d
end

function module:notification(properties)
    local x = module.x
    local y = module.y
    
    -- change values
    module.y -= 55
    
    -- create elements
    local outer = module:create('frame', {
        Position = Vector2.new(x - 350, y),
        Size = Vector2.new(350, 50),
        Color = Color3.fromRGB(0, 0, 0),
        Filled = true,
        Visible = true
    })
    local inner_outline = module:create('frame', {
        Position = Vector2.new(99999, 99999),
        Size = Vector2.new(outer.Size.X - 2, outer.Size.Y - 2),
        Color = module.accent,
        Filled = false,
        Visible = true
    })
    local inner = module:create('frame', {
        Position = Vector2.new(99999, 99999),
        Size = Vector2.new(inner_outline.Size.X - 2, inner_outline.Size.Y - 2),
        Color = Color3.fromRGB(30, 30, 30),
        Filled = true,
        Visible = true
    })
    local progress_bar = module:create('frame', {
        Position = Vector2.new(99999, 99999),
        Color = Color3.fromRGB(255, 255, 255),
        Filled = true,
        Visible = true
    })
    local title = module:create('text', {
        Position = Vector2.new(99999, 99999),
        Text = properties.Title,
        Size = 15,
        Color = module.accent,
        Visible = true
    })
    local text = module:create('text', {
        Position = Vector2.new(99999, 99999),
        Text = properties.Text,
        Size = 14,
        Color = Color3.fromRGB(255, 255, 255),
        Visible = true
    })
    
    -- functions
    coroutine.wrap(function()
        while wait() and outer.Position.Y ~= y - 50 do
            outer.Position = Vector2.new(outer.Position.X, outer.Position.Y - 5)
            inner_outline.Position = Vector2.new(outer.Position.X + 1, outer.Position.Y + 1)
            inner.Position = Vector2.new(inner_outline.Position.X + 1, inner_outline.Position.Y + 1)
            progress_bar.Position = Vector2.new(inner.Position.X + 5, inner.Position.Y + 2)
            title.Position = Vector2.new(x - 175, outer.Position.Y + 5)
            text.Position = Vector2.new(x - 175, outer.Position.Y + 30)
        end
    end)()
    module:tween(progress_bar, {
        Duration = properties.Duration,
        
        Start = Vector2.new(0, 1),
        End = Vector2.new(334, 1),
        
        Callback = function()
            coroutine.wrap(function()
                while wait() and outer.Position.Y ~= y do
                    outer.Position = Vector2.new(outer.Position.X, outer.Position.Y + 5)
                    inner_outline.Position = Vector2.new(outer.Position.X + 1, outer.Position.Y + 1)
                    inner.Position = Vector2.new(inner_outline.Position.X + 1, inner_outline.Position.Y + 1)
                    progress_bar.Position = Vector2.new(inner.Position.X + 5, inner.Position.Y + 2)
                    title.Position = Vector2.new(x - 175, outer.Position.Y + 5)
                    text.Position = Vector2.new(x - 175, outer.Position.Y + 30)
                end
                
                outer:Remove()
                inner_outline:Remove()
                inner:Remove()
                progress_bar:Remove()
                title:Remove()
                text:Remove()
                
                module.y += 55
            end)()
        end
    })
end

return module