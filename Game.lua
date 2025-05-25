require "Alienz"
require "Player"
require "Combat"
require "Attack"
require "Shop"
Game = Object:extend()


function Game:new()



    self.alienz = {}
    self.alienzIcon = {}
    self.music = {}
    table.insert(self.music, love.audio.newSource("music/0_menu.mp3", "stream"))
    table.insert(self.music, love.audio.newSource("music/4_battle.mp3", "stream"))
    table.insert(self.music, love.audio.newSource("music/Stinger_Victory_1_Master.mp3", "stream"))
    table.insert(self.music, love.audio.newSource("music/2_town.mp3", "stream"))
    table.insert(self.music, love.audio.newSource("music/5_defeat.mp3", "stream"))
    
    self.music[1]:setVolume(0.1)
    self.music[1]:isLooping(true)
    self.music[1]:play()

    self.music[2]:setVolume(0.1)
    self.music[2]:isLooping(true)

    self.music[3]:setVolume(0.1)

    self.music[4]:setVolume(0.1)
    self.music[4]:isLooping(true)

    self.music[5]:setVolume(0.1)
    self.music[5]:isLooping(false)

    self.shop = Shop()
    self.combat = nil

    self.bg = love.graphics.newImage("assets/bg.jpg")
    self.dedBg = love.graphics.newImage("assets/ded.jpg")
    self.dedFont = love.graphics.newFont("assets/font.ttf",25)
    self.combatBg = love.graphics.newImage("assets/combatBg.jpg")

    self.attacks = {}

    table.insert(self.attacks, Attack("Slash", 10, 10, Animation(lg.newImage("attacks/slash1.png"), 48, 48, 1)))
    table.insert(self.attacks, Attack("Tackle", 15, 15, Animation(lg.newImage("attacks/slash2.png"), 48, 48, 1)))
    table.insert(self.attacks, Attack("Flame", 20, 20, Animation(lg.newImage("attacks/fire1.png"), 48, 48, 1)))
    table.insert(self.attacks, Attack("Wind Slash", 20, 20, Animation(lg.newImage("attacks/leaf1.png"), 48, 48, 1)))

    table.insert(self.alienz, Alienz(30,5,4,1,"Mygnite",lg.newImage("alienz/big_alienz0.png"), {self.attacks[1]}, 64))
    table.insert(self.alienz, Alienz(25,6,5,1,"Ryder",lg.newImage("alienz/big_alienz1.png"), {self.attacks[1]}, 64))
    table.insert(self.alienz, Alienz(15,4,8,1,"Bottlepede",lg.newImage("alienz/big_alienz2.png"), {self.attacks[2]}, 32))
    table.insert(self.alienz, Alienz(40,5,2,1,"Umbrapod",lg.newImage("alienz/big_alienz3.png"), {self.attacks[1], self.attacks[3]}, 64))
    table.insert(self.alienz, Alienz(20,5,5,1,"Blorp",lg.newImage("alienz/big_alienz4.png"), {self.attacks[2]}, 64))
    table.insert(self.alienz, Alienz(19,6,10,1,"Sporz",lg.newImage("alienz/big_alienz5.png"), {self.attacks[1], self.attacks[2]}, 64))
    table.insert(self.alienz, Alienz(18,8,8,1,"Ghidle",lg.newImage("alienz/big_alienz6.png"), {self.attacks[3]}, 128))
    table.insert(self.alienz, Alienz(18,8,8,1,"Atoz",lg.newImage("alienz/big_alienz7.png"), {self.attacks[4]}, 128))

    table.insert(self.alienzIcon, lg.newImage("alienz/alienz0.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz1.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz2.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz3.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz4.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz5.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz6.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz7.png"))

    self.player = Player()

    self.fontName = love.graphics.newFont("assets/font.ttf",30)

    self.option = 2
    --starts at 0
    self.state = 0

    self.tutorial = true -- Should start at True
    self.tutorialSkip = false

    self.fadeAwayMaxTimer = 2
    self.fadeAwayTimer = self.fadeAwayMaxTimer

    self.fightCounter = 1
    self.fightLevel = 1

    self.gameOver = false

end

function Game:reset()

    for i, v in ipairs(self.music) do
        v:stop()
    end

end

function Game:nextFight()

    self.fightCounter = self.fightCounter + 1



    local r = 1


    if(self.fightCounter < 10) then
        r = math.random(1,3)

        self.fightLevel = self.fightLevel + 1
       
        
    elseif(self.fightCounter < 15) then
        r = math.random(1,6)

        self.fightLevel = self.fightLevel + 5
    

    elseif(self.fightCounter < 20) then
        r = math.random(1,8)
        self.fightLevel = self.fightLevel * 1.5
    end

    self.fightLevel = math.floor(self.fightLevel)
    local a = self.alienz[r]:getAlienz(self.fightLevel)

    if(self.fightCounter < 3) then
        a.ap = 0
    end

    return a

end


function Game:update(dt)


    if(textBox.active == false and self.state == 0) then
        self.state = 1
    end

    if(self.state == 10) then
        self.fadeAwayTimer = self.fadeAwayTimer+dt

        if(self.fadeAwayTimer > self.fadeAwayMaxTimer) then
            self.fadeAwayTimer = self.fadeAwayMaxTimer
        end
    end

    if(self.combat ~= nil) then

        self.combat:update(dt)

        if(self.combat.state == 8 and self.state == 3) then

            self.music[3]:play()
            self.music[2]:stop()

            if(self.combat.captured == true) then
                textBox:queueText("You didn't gain gold or experience from uploading " .. self.combat.enemyAlienz.name)
                self.state = 4
                self.fadeAwayTimer = self.fadeAwayMaxTimer
            else

                textBox:queueText("You deafeated " .. self.combat.enemyAlienz.name)
                textBox:queueText("Your Alienz gained 10 exp")
                self.combat.activePlayerAlienz.exp = self.combat.activePlayerAlienz.exp + 10
                if(self.combat.activePlayerAlienz.exp >= self.combat.activePlayerAlienz.requiredExp) then
                    self.combat.activePlayerAlienz:levelUp()
                    textBox:queueText(self.combat.activePlayerAlienz.name .. " Leveled Up to level " .. self.combat.activePlayerAlienz.level)
                end
                
                textBox:queueText("You also gained " .. self.combat.enemyAlienz.goldValue .. " gold")
                self.player.gold = self.player.gold + self.combat.enemyAlienz.goldValue

                self.state = 4
                self.fadeAwayTimer = self.fadeAwayMaxTimer

            end

        end

        if(self.combat.state == 9 and textBox.active == false) then
            self.state = 9
            self.fadeAwayTimer = self.fadeAwayTimer-dt

            if(self.fadeAwayTimer < 0) then
                self.gameOver = true
                self.combat = nil
                self.state = 10
            end

        end
        

    end

    if(self.state == 4 and textBox.active == false) then
        self.fadeAwayTimer = self.fadeAwayTimer - dt

        if(self.fadeAwayTimer <= 0) then
            self.combat:endCombat()
            self.combat = nil
            self.fadeAwayTimer = 0
            self.state = 5
            self.music[3]:stop()
            self.music[4]:play()
        end

    end

    if(self.state == 5) then
        self.shop:update(dt)

        if(self.shop.shoppingDone == true) then

            self.fadeAwayTimer = self.fadeAwayTimer-dt

            if(self.fadeAwayTimer < 0) then
                self.shop.shoppingDone = false
                self.shop.fadeInDone = false
                self.shop.menuOption = 1
                local a = self:nextFight()
                self.combat = Combat(a, self.player.myAlienz[1])
                self.state = 2         
            end    
        end
    end

    if(self.state == 5 and self.fadeAwayTimer < self.fadeAwayMaxTimer and self.shop.shoppingDone == false) then
        self.fadeAwayTimer = self.fadeAwayTimer+dt

         if((self.fadeAwayTimer >= self.fadeAwayMaxTimer) and self.tutorial == true) then
            self.tutorial = false
            self.shop.fadeInDone = true
            textBox:queueText("Between battles you will enter the shop")
            textBox:queueText("Using the gold you get from defeating Alienz")
            textBox:queueText("You can either upgrade your disk's space")
            textBox:queueText("Or buy significant upgrades for your Alienz")
         elseif ((self.fadeAwayTimer >= self.fadeAwayMaxTimer)) then
            self.shop.fadeInDone = true
         end

         


    end


    if(self.state == 3 and self.fadeAwayTimer < self.fadeAwayMaxTimer) then

        self.fadeAwayTimer = self.fadeAwayTimer+dt
        self.combat.state = 0

        if((self.fadeAwayTimer >= self.fadeAwayMaxTimer) and self.tutorial == true) then
            textBox:queueText("Battle begins here")
            textBox:queueText("Attacking costs AP -attack points-")
            textBox:queueText("Defending reduces the next incoming attack and recovers AP")
            textBox:queueText("Defeat the enemy or try and upload it")
            textBox:queueText("Reduce enemy HP before uploading it to your disk")
            textBox:queueText("Doing so will make it take up less space")
            textBox:queueText("Be careful though, you have limited disk space!")
            
        elseif(self.fadeAwayTimer >= self.fadeAwayMaxTimer) then
            textBox:queueText("A wild " .. self.combat.enemyAlienz.name .. " appears")
        end
    end

    if(self.state == 2 and self.tutorial == true) then
        
        if(textBox.active == false) then
            
            self.fadeAwayTimer = self.fadeAwayTimer-dt

            if(self.fadeAwayTimer < 0) then

                if(self.tutorialSkip == true) then
                    self.tutorial = false
                end

                self.state = 3
                local tutorialAlienz = self.alienz[3]:getAlienz(1)
                tutorialAlienz.ap = 0
                self.combat = Combat(tutorialAlienz, self.player.myAlienz[1])
                self.music[1]:stop()
                self.music[2]:play()
            end
        end
    elseif(self.state == 2) then
        self.fadeAwayTimer = self.fadeAwayTimer-dt
        if(self.fadeAwayTimer < 0) then
                self.state = 3
                self.music[4]:stop()
                self.music[2]:play()
            end
    end
end

function Game:keyPressed(key)

    if(self.combat ~= nil) then
        self.combat:keyPressed(key)
    end

    if(self.state == 5) then
        self.shop:keyPressed(key)
    end

    if(self.state == 1) then
        
        if(key == "d" or key == "right") then
            self.option = self.option+1

            if(self.option > 3) then
                self.option = 3
            end
        end

        if(key == "a" or key == "left") then
            self.option = self.option-1

            if(self.option < 1) then
                self.option = 1
            end
        end

        if(key ==  "space") then
            if(self.option == 1) then
                table.insert(self.player.myAlienz, self.alienz[2]:getAlienz(1))
            end

            if(self.option == 2) then
                table.insert(self.player.myAlienz, self.alienz[1]:getAlienz(1))
            end

            if(self.option == 3) then
                table.insert(self.player.myAlienz, self.alienz[5]:getAlienz(1))
            end

            self.state = 2
            self.player.diskSpace = self.player.diskSpace + self.player.myAlienz[1].diskSpace

            textBox:queueText(self.player.myAlienz[1].name .. " makes an excellent choice !")
            textBox:queueText("Let me upload him to your disk...")
            textBox:queueText("...")
            textBox:queueText("Upload Complete !")
            textBox:queueText("Your Journey will begin shortly...")

        end

    end

end

function Game:draw()
    
    if(self.state == 5) then
        local alpha = map(self.fadeAwayTimer, self.fadeAwayMaxTimer, 0, 1, 0)
        self.shop:draw(alpha)
    end

    if(self.combat ~= nil) then
        local alpha = map(self.fadeAwayTimer, self.fadeAwayMaxTimer, 0, 1, 0)

        lg.push()
        lg.setColor(1,1,1,alpha)
            lg.scale(2)
            lg.draw(self.combatBg)
        lg.pop()


        lg.push()
            self.combat:draw(alpha)
        lg.pop()

    end

    if(self.state == 0 or self.state == 1 or self.state == 2) then
        local alpha = map(self.fadeAwayTimer, self.fadeAwayMaxTimer, 0, 1, 0)
        lg.push() 
            lg.setColor(1,1,1,alpha)
            lg.scale(2)
            lg.draw(self.bg)
        lg.pop()
    end
    
    
    if(self.state == 1) then
        lg.setColor(1,1,1)
        lg.setFont(self.fontName)
        lg.push()
            lg.translate(lg.getWidth()/2-lg.getWidth()/4, lg.getHeight()/4)
            lg.scale(3.5)
            lg.draw(self.alienz[2].sprite,0,0,0,1,1,16,16)
        lg.pop()

        lg.push()
            if(self.option == 1) then
                lg.setColor(0,0,0)
                lg.translate(lg.getWidth()/2-lg.getWidth()/4, lg.getHeight()/4)
                lg.translate(0,48)
                lg.polygon("fill",0,0,-10,10,10,10)
                lg.translate(0,10)
                lg.print(self.alienz[2].name,-(self.fontName:getWidth(self.alienz[2].name)/2),0)
            end
        lg.pop()

        lg.push()
            lg.setColor(1,1,1)
            lg.translate(lg.getWidth()/2, lg.getHeight()/4)
            lg.scale(3.5)
            lg.draw(self.alienz[1].sprite,0,0,0,1,1,16,16)

        lg.pop()

        lg.push()
            if(self.option == 2) then
                lg.setColor(0,0,0)
                lg.translate(lg.getWidth()/2, lg.getHeight()/4)
                lg.translate(0,48)
                lg.polygon("fill",0,0,-10,10,10,10)
                lg.translate(0,10)
                lg.print(self.alienz[1].name,-(self.fontName:getWidth(self.alienz[1].name)/2),0)
            end
        lg.pop()


        lg.push()
            lg.setColor(1,1,1)
            lg.translate(lg.getWidth()/2+lg.getWidth()/4, lg.getHeight()/4)
            lg.scale(3.5)
            lg.draw(self.alienz[5].sprite,0,0,0,1,1,16,16)
        lg.pop()

        lg.push()
            if(self.option == 3) then
                lg.setColor(0,0,0)
                lg.translate(lg.getWidth()/2+lg.getWidth()/4, lg.getHeight()/4)
                lg.translate(0,48)
                lg.polygon("fill",0,0,-10,10,10,10)
                lg.translate(0,10)
                lg.print(self.alienz[5].name,-(self.fontName:getWidth(self.alienz[5].name)/2),0)
            end
        lg.pop()




        
    end

    if(self.state == 10) then
        lg.push()
            local alpha = map(self.fadeAwayTimer, self.fadeAwayMaxTimer, 0, 1, 0)
            lg.setColor(1,1,1,alpha)
            lg.draw(self.dedBg)
            lg.translate(lg.getWidth()/2, lg.getHeight()/2)
            lg.setFont(self.dedFont)
            lg.print("Your disk was factory reset",-self.dedFont:getWidth("Your disk was factory reset")/2,0)
            lg.print("Press R to play again",-self.dedFont:getWidth("Press R to play again")/2,50)
            
        lg.pop()
    end

end


