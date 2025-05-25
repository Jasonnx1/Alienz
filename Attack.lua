
Attack = Object:extend()


function Attack:new(name, power, cost, animation)

    self.name = name
    self.power = power
    self.cost = cost
    self.animation = animation

end



function Attack:update(dt)

    self.animation:update(dt)

    if(self.animation.done == true) then
        self.animation.done = false
        game.combat.attackState = 2
    end


end



function Attack:draw()

    lg.push()
        lg.scale(3)
        self.animation:draw()
    lg.pop()

end


