Animation = Object:extend()


function Animation:new(image, width, height, duration)

    self.spriteSheet = image;
    self.quads = {};
    self.width = width
    self.height = height
    self.done = false

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(self.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    self.duration = duration or 1
    self.currentTime = 0

end


function Animation:update(dt)

    self.currentTime = self.currentTime + dt
    if(self.currentTime >= self.duration) then
        self.currentTime = self.currentTime - self.duration
        self.done = true
    end

end

function Animation:draw()
    local spriteNum = math.floor(self.currentTime / self.duration * #self.quads) + 1
    love.graphics.draw(self.spriteSheet, self.quads[spriteNum],0,0,0,1,1,self.width/2, self.height/2)
end


