Alienz = Object:extend()


function Alienz:new(hp, att, def, level, name, sprite, attacks, diskSpace)

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
    self.ap = self.maxAp/2
    self.selectedAttack = nil
    self.defending = false
    self.regenRate = 10
    self.goldValue = 0

    self.diskSpaceValue = diskSpace
    self.diskSpaceMax = self.diskSpaceValue * level
    self.diskSpace = self.diskSpaceMax
    

    -- Subject to get buffed
    self.currAtt = self.att
    self.currDef = self.def
    self.currApRegen = self.regenRate
    

end

function Alienz:getAlienz(level)

    local hp = self.hp + ((self.hp/10) * (level-1))
    local att = self.att + ((self.att/10) * (level-1))
    local def = self.def + ((self.def/10) * (level-1))

    local ali = Alienz(hp,att,def,level,self.name, self.sprite, self.attacks, self.diskSpaceValue)

    ali.goldValue = math.random(5,10) + (math.floor(math.random() * ali.level))
    ali.exp = 1

    return ali
end

function Alienz:levelUp()

    self.exp = 0
    self.requiredExp = 10 + (self.level*self.level)
    self.level = self.level + 1

    self.hp = self.hp + (self.hp/10)
    self.att = self.att + (self.att/10)
    self.def = self.def + (self.def/10)

end

function Alienz:adjustDiskSpace()

    local p = self.currentHp / self.hp

    self.diskSpace = math.floor(self.diskSpaceMax * p)


end

function Alienz:applyBuffs(a, d, r)

    self.currAtt = self.att * a
    self.currDef = self.def * d
    self.currApRegen = self.regenRate * r

end

function Alienz:resetStats()

    self.currentHp = self.hp
    self.currAtt = self.att
    self.currDef = self.def
    self.currApRegen = self.regenRate
    self.ap = self.maxAp/2
    

end

function Alienz:update(dt)


end

function Alienz:draw()

    

end


