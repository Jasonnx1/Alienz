
Combat = Object:extend()


function Combat:new(enemyAlienz, activePlayerAlienz)

    self.enemyAlienz = enemyAlienz
    self.activePlayerAlienz = activePlayerAlienz

    self.activePlayerAlienz:applyBuffs(game.player.attUpgrade, game.player.defUpgrade, game.player.regenUpgrade)

    self.enemyAlienz.ap = 0--self.enemyAlienz.maxAp/2
    self.activePlayerAlienz.ap = self.activePlayerAlienz.maxAp/2

    --State:
    -- 0 = waiting on text
    -- 1 = choose attack
    -- 2 = attack animation
    -- 3 = enemy attacks
    -- 4 = Waiting on Enemy Defend
    -- 5 = waiting on Ally Defend
    self.state = 0

    --Menu States:
    -- 0 = Choose Action
    -- 1 = Choose Attack
    -- 2 = Defend - no Menu
    -- 3 = Capture - no Menu
    self.menuState = 0
    self.menuOption = 1

    --Attack States:
    -- 0 = Text Display of Attack
    -- 1 = Play Animation
    -- 2 = Deal Damage
    -- 3 = Attacking Done
    self.attackState = 0
    

    self.font = lg.newFont("assets/font.ttf", 20)

end

function Combat:dealDamage(attacker, target)

    local d = attacker.selectedAttack.power * (attacker.currAtt / target.currDef)
    if(target.defending == true) then
        d = d/2
        target.defending = false
    end

    if(d < 1) then
        d = 1
    end

    target.currentHp = target.currentHp - d

    if(target.currentHp < 0) then
        target.currentHp = 0
    end

end

function Combat:endCombat()

    self.activePlayerAlienz:resetStats()

end


function Combat:update(dt)

    if(self.state == 7) then
        if(textBox.active == false) then
            self.state = 1
        end
    end

    if(self.state == 4) then

        if(textBox.active == false) then
            self.state = 1
            self.menuOption = 1
            self.attackState = 0
        end
        
    end

    if(self.state == 5) then

        if(textBox.active == false) then
            self.state = 3
        end
        
    end

    if(self.state == 3) then

           
        if(textBox.active == false and self.attackState == 4) then
            self.attackState = 1
        end
      
        
        if(self.attackState == 0) then
            
            local availableAttacks = {}

            for i, v in ipairs(self.enemyAlienz.attacks) do
                if(v.cost <= self.enemyAlienz.ap) then
                    table.insert(availableAttacks, v)
                end
            end

            if(#availableAttacks > 0) then
                local r = math.random(1, #availableAttacks)
                self.enemyAlienz.selectedAttack = availableAttacks[r]
                self.attackState = 4
                self.enemyAlienz.ap = self.enemyAlienz.ap - self.enemyAlienz.selectedAttack.cost
                local m = self.enemyAlienz.name .. " used " .. self.enemyAlienz.selectedAttack.name .. "!"
                textBox:queueText(m)
            else
                self.enemyAlienz.ap = self.enemyAlienz.ap + self.enemyAlienz.currApRegen
                if(self.enemyAlienz.ap > self.enemyAlienz.maxAp) then
                    self.enemyAlienz.ap = self.enemyAlienz.maxAp
                end
                self.enemyAlienz.defending = true
                self.state = 4
                textBox:queueText(self.enemyAlienz.name .. " is defending your next attack...")
            end
        end
    end

    if(self.state == 0) then
        if(textBox.active == false) then
            self.state = 1
            self.menuOption = 1
            self.attackState = 0
        end
    end

    if(self.state == 2 and self.attackState == 1) then

        self.activePlayerAlienz.selectedAttack:update(dt)
        if(self.attackState == 2) then

            self:dealDamage(self.activePlayerAlienz, self.enemyAlienz)

            if(self.enemyAlienz.currentHp == 0) then

                self.state = 8

            else

                self.state = 3
                self.attackState = 0

            end


        end

    end


    if(self.state == 3 and self.attackState == 1) then

        self.enemyAlienz.selectedAttack:update(dt)
        if(self.attackState == 2) then

            self:dealDamage(self.enemyAlienz, self.activePlayerAlienz)

            if(self.activePlayerAlienz.currentHp == 0) then
                --Combat is KO

            else

                self.state = 1
                self.menuOption = 1
                self.attackState = 0

            end


        end

    end


    if(self.attackState == 0 and self.state == 2) then
        if(textBox.active == false) then
            self.attackState = 1
        end
    end


end

function Combat:keyPressed(key)

    if(self.menuState == 1) then

        if(key == "down" or key == "s") then
            self.menuOption = self.menuOption + 1

            if(self.menuOption > #self.activePlayerAlienz.attacks) then
                self.menuOption = 1
            end
        end

        if(key == "up" or key == "w") then
            self.menuOption = self.menuOption - 1

            if(self.menuOption < 1) then
                self.menuOption = #self.activePlayerAlienz.attacks
            end

        end

        if(key == "backspace" or key == "escape" or key == "x") then
            self.menuOption = 1
            self.menuState = 0
        end

        if(key == "space") then

            if(self.activePlayerAlienz.attacks[self.menuOption].cost <= self.activePlayerAlienz.ap) then
                self.state = 2
                self.menuState = 0
                self.attackState = 0
                self.activePlayerAlienz.selectedAttack = self.activePlayerAlienz.attacks[self.menuOption]
                self.activePlayerAlienz.ap = self.activePlayerAlienz.ap - self.activePlayerAlienz.selectedAttack.cost
                local m = self.activePlayerAlienz.name .. " used " .. self.activePlayerAlienz.selectedAttack.name .. "!"
                textBox:queueText(m)
            else
                textBox:queueText("Not enough AP !")
                self.state = 7
            end
        end
    end

    if(self.menuState == 0) then

        if(key == "down" or key == "s") then
            self.menuOption = self.menuOption + 1

            if(self.menuOption > 3) then
                self.menuOption = 1
            end
        end

        if(key == "up" or key == "w") then
            self.menuOption = self.menuOption - 1

            if(self.menuOption < 1) then
                self.menuOption = 3
            end
        end

        if(key == "space" and  self.state == 1) then
            if(self.menuOption == 1) then
                self.menuState = 1
            end

            if(self.menuOption == 2) then
                self.activePlayerAlienz.defending = true
                self.activePlayerAlienz.ap = self.activePlayerAlienz.ap + self.activePlayerAlienz.currApRegen
                textBox:queueText(self.activePlayerAlienz.name .. " is defending...")
                self.state = 5
            end
        end
    end
end

function Combat:draw(alpha)

    local playerPos = {lg.getWidth()/2 - lg.getWidth()/3, lg.getHeight()/2+lg.getHeight()/16}
    local enemyPos = {lg.getWidth()/2 + lg.getWidth()/3, lg.getHeight()/2+lg.getHeight()/16}

    lg.push()
        --Draw My Alienz
        lg.setColor(0,0,0,0.4)
        lg.translate(playerPos[1], playerPos[2])
        lg.ellipse("fill",0,0,50,20)
        lg.setColor(1,1,1,alpha)
        lg.translate(0,-32)
        lg.scale(3)
        lg.draw(self.activePlayerAlienz.sprite,0,0,0,1,1,16,16)

    lg.pop()

    lg.push()

        lg.translate(playerPos[1], playerPos[2])
        local per = self.activePlayerAlienz.currentHp/self.activePlayerAlienz.hp
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", -self.activePlayerAlienz.sprite:getWidth()*2,0,7,-self.activePlayerAlienz.sprite:getHeight()*2)
        love.graphics.setColor(0.8, 0.1, 0.2, 1)
        love.graphics.rectangle("fill", -self.activePlayerAlienz.sprite:getWidth()*2,0,7,-self.activePlayerAlienz.sprite:getHeight()*2*(per))

        local per = self.activePlayerAlienz.ap/self.activePlayerAlienz.maxAp
        lg.translate(-15, 0)
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", -self.activePlayerAlienz.sprite:getWidth()*2,0,7,-self.activePlayerAlienz.sprite:getHeight()*2)
        love.graphics.setColor(0.1, 0.1, 0.8, 1)
        love.graphics.rectangle("fill", -self.activePlayerAlienz.sprite:getWidth()*2,0,7,-self.activePlayerAlienz.sprite:getHeight()*2*(per))
        

    lg.pop()

    lg.push()
        lg.translate(playerPos[1], playerPos[2])
        lg.setColor(love.math.colorFromBytes(63, 166, 94))
        lg.print(self.activePlayerAlienz.name,-(self.font:getWidth(self.activePlayerAlienz.name)/2),0)   
    lg.pop()



    lg.push()
        --Draw Enemy Alienz
        lg.setColor(0,0,0,0.4)
        lg.translate(enemyPos[1], enemyPos[2])
        lg.ellipse("fill",0,0,50,20)
        lg.setColor(1,1,1,alpha)
        lg.translate(0,-32)
        lg.scale(3)
        lg.draw(self.enemyAlienz.sprite,0,0,0,-1,1,16,16)

    lg.pop()

    lg.push()
        lg.translate(enemyPos[1], enemyPos[2])
        local per = self.enemyAlienz.currentHp/self.enemyAlienz.hp
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", self.enemyAlienz.sprite:getWidth()*2,0,7,-self.enemyAlienz.sprite:getHeight()*2)
        love.graphics.setColor(0.8, 0.1, 0.2, 1)
        love.graphics.rectangle("fill", self.enemyAlienz.sprite:getWidth()*2,0,7,-self.enemyAlienz.sprite:getHeight()*2*(per))  
        
        local per = self.enemyAlienz.ap/self.enemyAlienz.maxAp
        lg.translate(15,0)
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", self.enemyAlienz.sprite:getWidth()*2,0,7,-self.enemyAlienz.sprite:getHeight()*2)
        love.graphics.setColor(0.1, 0.1, 0.8, 1)
        love.graphics.rectangle("fill", self.enemyAlienz.sprite:getWidth()*2,0,7,-self.enemyAlienz.sprite:getHeight()*2*(per))
    lg.pop()

    lg.push()
        lg.translate(enemyPos[1], enemyPos[2])
        lg.setColor(love.math.colorFromBytes(199, 28, 79))
        lg.print(self.enemyAlienz.name,-(self.font:getWidth(self.enemyAlienz.name)/2),0)   
    lg.pop()

    if(self.state == 2 and self.attackState == 1) then

        lg.push()
            lg.translate(enemyPos[1], enemyPos[2]-16)
            self.activePlayerAlienz.selectedAttack:draw()
        lg.pop()

    end

    if(self.state == 3 and self.attackState == 1) then

        lg.push()
            lg.translate(playerPos[1], playerPos[2]-16)
            self.enemyAlienz.selectedAttack:draw()
        lg.pop()

    end

    if(self.state == 1) then

            lg.push()
                --Combat UI
                local lineWidth = 5
                love.graphics.setLineWidth(lineWidth)
                lg.setColor(love.math.colorFromBytes(104, 76, 158))
                love.graphics.rectangle("line", lineWidth/2 ,lg.getHeight()-lg.getHeight()/4-(lineWidth/2),lg.getWidth()-(lineWidth),lg.getHeight()/4)
                lg.setColor(0,0,0,0.8)
                love.graphics.rectangle("fill", lineWidth ,lg.getHeight()-lg.getHeight()/4,lg.getWidth()-(lineWidth*2),lg.getHeight()/4-(lineWidth))
            lg.pop()

            if(self.menuState == 0) then
                lg.setFont(self.font)

                lg.push()
                    lg.setColor(1,1,1)
                    lg.translate(lg.getWidth()/2, lg.getHeight()/2+ lg.getHeight()/4)
                    lg.print("Choose an action",-(self.font:getWidth("Choose an action")/2),0)
                lg.pop()

                local i = 1
                lg.push()
                    lg.setColor(1,1,1)
                    lg.translate(lg.getWidth()/2, lg.getHeight()/2+lg.getHeight()/4+(lg.getHeight()/16*i))
                    lg.print("Attack",-(self.font:getWidth("Attack")/2),0)

                    if(self.menuOption == 1) then
                        lg.translate(-(self.font:getWidth("Attack")/2)-5, self.font:getHeight()/2)
                        lg.polygon("fill", 0, 0, -10,5, -10,-5)
                    end
                lg.pop()

                i = i+1
                lg.push()
                    lg.setColor(1,1,1)
                    lg.translate(lg.getWidth()/2, lg.getHeight()/2+lg.getHeight()/4+(lg.getHeight()/16*i))
                    lg.print("Defend",-(self.font:getWidth("Defend")/2),0)

                    if(self.menuOption == 2) then
                        lg.translate(-(self.font:getWidth("Defend")/2)-5, self.font:getHeight()/2)
                        lg.polygon("fill", 0, 0, -10,5, -10,-5)
                    end
                lg.pop()

                i = i+1
                lg.push()
                    lg.setColor(1,1,1)
                    lg.translate(lg.getWidth()/2, lg.getHeight()/2+lg.getHeight()/4+(lg.getHeight()/16*i))
                    lg.print("Capture",-(self.font:getWidth("Capture")/2),0)
                    if(self.menuOption == 3) then

                        lg.translate(-(self.font:getWidth("Capture")/2)-5, self.font:getHeight()/2)
                        lg.polygon("fill", 0, 0, -10,5, -10,-5)
                    end
                lg.pop()       
            end

            if(self.menuState == 1) then
                lg.setFont(self.font)

                lg.push()
                    lg.setColor(1,1,1)
                    lg.translate(lg.getWidth()/2, lg.getHeight()/2+ lg.getHeight()/4)
                    lg.print("Choose an action",-(self.font:getWidth("Choose an attack")/2),0)
                lg.pop()


                for i, v in ipairs(self.activePlayerAlienz.attacks) do
                    lg.push()
                        lg.setColor(1,1,1)
                        if(v.cost > self.activePlayerAlienz.ap) then
                            lg.setColor(0.5,0.5,0.5)
                        end
                        lg.translate(lg.getWidth()/2, lg.getHeight()/2+lg.getHeight()/4+(lg.getHeight()/24*i))
                        lg.print(v.name,-(self.font:getWidth(v.name)/2),0)
                        if(self.menuOption == i) then
                            lg.setColor(1,1,1)
                            lg.translate(-self.font:getWidth(v.name)/2 - 5, self.font:getHeight()/2)
                            lg.polygon("fill", 0, 0, -10,5, -10,-5)
                        end
                    lg.pop()
                end
            end


    end



    

end


