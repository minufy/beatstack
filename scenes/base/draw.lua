return function (Scene)
    function Scene:draw_objects()
        for _, group in pairs(self.objects) do
            for _, object in ipairs(group) do
                if object.draw then
                    object:draw()
                end
            end
        end
    end
end
