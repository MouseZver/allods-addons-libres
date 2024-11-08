function DestroyWidgetsInContainer(container)
    local cached_widgets = {}
    local items_count = container:GetElementCount()
    if items_count > 0 then
        for i = 0, items_count - 1 do
            cached_widgets[i] = container:At(i)
        end
    end

    container:RemoveItems()
    
    for i, v in pairs(cached_widgets) do
        v:DestroyWidget()
    end
end
