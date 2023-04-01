return {
    Draw = function(Object, Properties)
        if Object == "Cham" then
            local Highlight = Instance.new("Highlight")
            for Property, Value in next, Properties do
                Highlight[Property] = Value
            end
            
            return Highlight
        end
        
        local Drawn = Drawing.new(Object)
        for Property, Value in next, Properties do
            Drawn[Property] = Value
        end
    
        return Drawn
    end
}