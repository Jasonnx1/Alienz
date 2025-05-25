
Shop = Object:extend()


function Shop:new()

    self.shopBg = lg.newImage("assets/shopBg.jpg")
    self.goldFont = lg.newFont("assets/font.ttf", 35)
    self.shopFont = lg.newFont("assets/font.ttf", 30)
    self.font = lg.newFont("assets/font.ttf", 16)

    self.items = {{"Attack Upgrade", 5},{"Defense Upgrade", 5},{"AP Regen Upgrade", 5},{"Disk Upgrade", 8}, {"Learn Wind Slash", 10}, {"Learn Flame", 10}}

    self.menuOption = 1

    self.shoppingDone = false


end


function Shop:update(dt)


end

function Shop:keyPressed(key)

    if(self.shoppingDone == false) then

        if(key == "up" or key == "w") then

            self.menuOption = self.menuOption - 1
            if(self.menuOption < 1) then
                self.menuOption = 7
            end
            
        end


        if(key == "down" or key == "s") then

            
            self.menuOption = self.menuOption + 1
            if(self.menuOption > 7) then
                self.menuOption = 1
            end
            
        end

        if(key == "space") then

            if(self.menuOption ~= 7) then
                
                if(self.menuOption == 1) then
                    if(game.player.gold >= self.items[self.menuOption][2]) then
                        game.player.attUpgrade = game.player.attUpgrade + 0.15
                        game.player.gold = game.player.gold - self.items[self.menuOption][2]
                    else
                        textBox:queueText("Not enough gold")
                    end
                end

                if(self.menuOption == 2) then
                    if(game.player.gold >= self.items[self.menuOption][2]) then
                        game.player.defUpgrade = game.player.defUpgrade + 0.15
                        game.player.gold = game.player.gold - self.items[self.menuOption][2]
                    else
                        textBox:queueText("Not enough gold")
                    end
                end

                if(self.menuOption == 3) then
                    if(game.player.gold >= self.items[self.menuOption][2]) then
                        game.player.regenUpgrade = game.player.regenUpgrade + 0.15
                        game.player.gold = game.player.gold - self.items[self.menuOption][2]
                    else
                        textBox:queueText("Not enough gold")
                    end
                end

                if(self.menuOption == 4) then
                    if(game.player.gold >= self.items[self.menuOption][2]) then
                        if(game.player.diskSpaceMax < 1024) then
                            game.player.gold = game.player.gold - self.items[self.menuOption][2]
                            game.player.diskSpaceMax = game.player.diskSpaceMax * 2
                        else
                            textBox:queueText("Already Max Upgrade")
                        end
                    else
                        textBox:queueText("Not enough gold")
                    end
                end

                if(self.menuOption == 5) then
                    if(game.player.gold >= self.items[self.menuOption][2]) then
                        
                        if(#game.player.myAlienz[1].attacks < 4) then
                            local alreadyHasMove = false
                            for i, v in ipairs(game.player.myAlienz[1].attacks) do

                                if(v.name == "Wind Slash") then
                                    alreadyHasMove = true
                                end
                                
                            end

                            if(alreadyHasMove == false) then
                                game.player.gold = game.player.gold - self.items[self.menuOption][2]
                                table.insert(game.player.myAlienz[1].attacks, game.attacks[4])
                            else
                                textBox:queueText(game.player.myAlienz[1].name .. " already has that attack")
                            end
                            
                        else
                            textBox:queueText(game.player.myAlienz[1].name .. " already has 4 moves")
                        end
                        
                    else
                        textBox:queueText("Not enough gold")
                    end
                end

                if(self.menuOption == 6) then
                    if(game.player.gold >= self.items[self.menuOption][2]) then
                        
                        if(#game.player.myAlienz[1].attacks < 4) then
                            local alreadyHasMove = false
                            for i, v in ipairs(game.player.myAlienz[1].attacks) do

                                if(v.name == "Flame") then
                                    alreadyHasMove = true
                                end
                                
                            end

                            if(alreadyHasMove == false) then
                                game.player.gold = game.player.gold - self.items[self.menuOption][2]
                                table.insert(game.player.myAlienz[1].attacks, game.attacks[3])
                            else
                                textBox:queueText(game.player.myAlienz[1].name .. " already has that attack")
                            end
                            
                        else
                            textBox:queueText(game.player.myAlienz[1].name .. " already has 4 moves")
                        end
                        
                    else
                        textBox:queueText("Not enough gold")
                    end
                end

            else
                self.shoppingDone = true
            end 

        end  

    end

    
end -- end of keyPressed Function

function Shop:draw(alpha)

    lg.push()
        lg.setColor(1,1,1,alpha)
        lg.scale(0.5)
        lg.draw(self.shopBg,0,0)
    lg.pop()

    lg.push()
        local w = 5
        lg.setColor(0,0,0,0.7)
        lg.rectangle("fill", 0,0, lg.getWidth()/2, lg.getHeight())

        lg.setColor(0.1,0.8,0.1,alpha)
        lg.setLineWidth(w)
        lg.rectangle("line", w/2,w/2, lg.getWidth()/2-w, lg.getHeight()-w)
    lg.pop()

    lg.push()
        
        lg.setFont(self.goldFont)
        lg.translate(lg.getWidth() - self.goldFont:getWidth("Gold: " .. game.player.gold), self.goldFont:getHeight())
        lg.setColor(0,0,0,0.4)
        lg.rectangle("fill", 0,0,self.goldFont:getWidth("Gold: " .. game.player.gold), self.goldFont:getHeight())
        lg.setColor(1,1,0,alpha)
        lg.print("Gold: " .. game.player.gold,5,0)
    lg.pop()

    lg.push()
        lg.setFont(self.shopFont)
        lg.translate((lg.getWidth()/2)/2, 25)
        lg.setColor(1,1,1,alpha)
        lg.print("Shop",- self.shopFont:getWidth("Shop")/2,0)
    lg.pop()

    for i, v in ipairs(self.items) do
        lg.push()
            lg.setColor(1,1,1,alpha)
            lg.translate(0,50)
            lg.setFont(self.font)
            lg.translate((lg.getWidth()/3)/8, 25)
            lg.print(v[1], 0, (i*50))

            if(game.player.gold >= v[2]) then
                lg.setColor(1,1,0,alpha)
            else
                lg.setColor(0.6,0.6,0,alpha)
            end
            
            lg.print(tostring(v[2]),lg.getWidth()/2.5,i*50)

            
            if(self.menuOption == i) then
                lg.setColor(1,1,1,alpha)
                lg.translate(-5, i*50)
                lg.polygon("fill", 0,self.font:getHeight()/2,-7,self.font:getHeight()/2-7, -7,self.font:getHeight()/2+7)
            end
        lg.pop()
    end

    lg.push()
        lg.setColor(1,1,1,alpha)
        lg.translate(0,50)
        lg.setFont(self.font)
        lg.translate((lg.getWidth()/3)/8, 25)
        lg.print("Done", 0, (350))


        if(self.menuOption == 7) then
            lg.setColor(1,1,1,alpha)
            lg.translate(-5, 350)
            lg.polygon("fill", 0,self.font:getHeight()/2,-7,self.font:getHeight()/2-7, -7,self.font:getHeight()/2+7)
        end
    lg.pop()

    
    lg.push()
        lg.setColor(0,0,0,0.7)
        lg.rectangle("fill",  lg.getWidth()/2, lg.getHeight()/2, lg.getWidth(), lg.getHeight())

        lg.setColor(0.1,0.8,0.1,alpha)
        lg.setLineWidth(w)
        lg.rectangle("line", lg.getWidth()/2-w/2, lg.getHeight()/2-w/2, lg.getWidth()/2, lg.getHeight()/2)
    lg.pop()


    lg.push()
        lg.translate(lg.getWidth()/2 + lg.getWidth()/4, lg.getHeight()/2)
        lg.setColor(1,1,1,alpha)
        lg.setFont(self.shopFont)
        lg.print("Stats", -self.shopFont:getWidth("Stats")/2,0)

        lg.translate(-lg.getWidth()/4 + w,25)
        lg.setFont(self.font)
        
        lg.print("Att modifier: " .. game.player.attUpgrade, 0, 50)
        lg.print("Def modifier: " .. game.player.defUpgrade, 0, 100)
        lg.print("AP modifier: " .. game.player.regenUpgrade, 0, 150)
        lg.print("Disk: " .. game.player.diskSpace .. "mb" .. " - " .. game.player.diskSpaceMax .. "mb", 0, 200)

    lg.pop()

end


