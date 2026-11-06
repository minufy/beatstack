local draw_order = {
    "board",
    "mino",
}

return function (Scene)
    function Scene:draw_objects()
        for _, group_name in ipairs(draw_order) do
            if self.objects[group_name] ~= nil then
                for _, object in ipairs(self.objects[group_name]) do
                    if object.draw then
                        object:draw()
                    end
                end
            end
        end
    end
end
