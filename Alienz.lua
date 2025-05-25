Alienz = Object:extend()


function Alienz:new(hp, att, def, level, name, sprite, attacks)

    self.hp = hp
    self.currentHp = hp
    self.att = att
    self.def = def
    self.level = level
    self.sprite = sprite
    self.name = name
    self.exp = 0
    self.requiredExp = 10 + (level*level)
    self.attacks = attacks
    self.maxAp = 50
    self.ap = self.maxAp
    self.selectedAttack = nil
    self.defending = false
    self.regenRate = 10
    

end

function Alienz:getAlienz(level)

    local hp = self.hp + ((self.hp/10) * (level-1))
    local att = self.att + ((self.att/10) * (level-1))
    local def = self.def + ((self.def/10) * (level-1))

    local ali = Alienz(hp,att,def,level,self.name, self.sprite, self.attacks)

    return ali
end

function Alienz:levelUp()

    self.exp = 0
    self.requiredExp = 10 + (self.level*self.level)

    self.hp = self.hp + (self.hp/10)
    self.att = self.att + (self.att/10)
    self.def = self.def + (self.def/10)


end

function Alienz:update(dt)


end

function Alienz:draw()

    

end


