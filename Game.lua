require "Alienz"
require "Player"
require "Combat"
require "Attack"
Game = Object:extend()


function Game:new()

    self.player = Player()

    self.alienz = {}
    self.alienzIcon = {}
    self.music = {}
    table.insert(self.music, love.audio.newSource("music/0_menu.mp3", "stream"))
    table.insert(self.music, love.audio.newSource("music/4_battle.mp3", "stream"))
    
    self.music[1]:setVolume(0.1)
    self.music[1]:isLooping(true)
    self.music[1]:play()

    self.music[2]:setVolume(0.1)
    self.music[2]:isLooping(true)
    

    self.combat = nil

    self.bg = love.graphics.newImage("assets/bg.jpg")
    self.combatBg = love.graphics.newImage("assets/combatBg.jpg")

    self.attacks = {}

    table.insert(self.attacks, Attack("Slash", 10, 10, Animation(lg.newImage("attacks/slash1.png"), 48, 48, 1)))
    table.insert(self.attacks, Attack("Tackle", 15, 20, Animation(lg.newImage("attacks/slash2.png"), 48, 48, 1)))
    table.insert(self.attacks, Attack("Flame", 20, 30, Animation(lg.newImage("attacks/fire1.png"), 48, 48, 1)))
    table.insert(self.attacks, Attack("Wind Slash", 20, 30, Animation(lg.newImage("attacks/leaf1.png"), 48, 48, 1)))

    table.insert(self.alienz, Alienz(30,5,4,1,"Mygnite",lg.newImage("alienz/big_alienz0.png"), {self.attacks[1], self.attacks[2], self.attacks[3], self.attacks[4]}))
    table.insert(self.alienz, Alienz(25,6,5,1,"Ryder",lg.newImage("alienz/big_alienz1.png"), {self.attacks[1], self.attacks[2]}))
    table.insert(self.alienz, Alienz(15,4,8,1,"Bottlepede",lg.newImage("alienz/big_alienz2.png"), {self.attacks[1], self.attacks[2]}))
    table.insert(self.alienz, Alienz(38,5,2,1,"Umbrapod",lg.newImage("alienz/big_alienz3.png"), {self.attacks[1], self.attacks[2]}))
    table.insert(self.alienz, Alienz(20,5,5,1,"Blorp",lg.newImage("alienz/big_alienz4.png"), {self.attacks[1], self.attacks[2]}))
    table.insert(self.alienz, Alienz(19,6,10,1,"Sporz",lg.newImage("alienz/big_alienz5.png"), {self.attacks[1], self.attacks[2]}))
    table.insert(self.alienz, Alienz(18,8,8,1,"Ghidle",lg.newImage("alienz/big_alienz6.png"), {self.attacks[1], self.attacks[2]}))
    table.insert(self.alienz, Alienz(18,8,8,1,"Atoz",lg.newImage("alienz/big_alienz7.png"), {self.attacks[1], self.attacks[2]}))

    table.insert(self.alienzIcon, lg.newImage("alienz/alienz0.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz1.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz2.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz3.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz4.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz5.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz6.png"))
    table.insert(self.alienzIcon, lg.newImage("alienz/alienz7.png"))

    self.fontName = love.graphics.newFont("assets/font.ttf",30)

    self.option = 2
    self.state = 0

    self.fadeAwayMaxTimer = 1
    self.fadeAwayTimer = self.fadeAwayMaxTimer

end


function Game:update(dt)

    if(textBox.active == false and self.state == 0) then
        self.state = 1
    end

    if(self.combat ~= nil) then
        self.combat:update(dt)
    end


    if(self.state == 3 and self.fadeAwayTimer < self.fadeAwayMaxTimer) then
        self.fadeAwayTimer = self.fadeAwayTimer+dt
        self.combat.state = 0

        if(self.fadeAwayTimer >= self.fadeAwayMaxTimer) then
            textBox:queueText("Battle begins here")
            textBox:queueText("Attacking costs AP -attack points-")
            textBox:queueText("Defending reduces the next incoming attack and recovers AP")
            textBox:queueText("Defeat the enemy or try and upload it")
            textBox:queueText("Reduce enemy HP before uploading it to your disk")
            textBox:queueText("Doing so will make it take up less space")
            textBox:queueText("Be careful though, you have limited disk space!")
        end
    end

    if(self.state == 2) then
        
        if(textBox.active == false) then
            
            self.fadeAwayTimer = self.fadeAwayTimer-dt

            if(self.fadeAwayTimer < 0) then
                self.state = 3
                self.combat = Combat(self.alienz[3]:getAlienz(1), self.player.myAlienz[1])
                self.music[1]:stop()
                self.music[2]:play()
            end
        end
    end
end

function Game:keyPressed(key)

    if(self.combat ~= nil) then
        self.combat:keyPressed(key)
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

            textBox:queueText(self.player.myAlienz[1].name .. " makes an excellent choice !")
            textBox:queueText("Let me upload him to your disk...")
            textBox:queueText("...")
            textBox:queueText("Upload Complete !")
            textBox:queueText("Your Journey will begin shortly...")

        end

    end

end

function Game:draw()
    

    if(self.state == 3) then
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

end


