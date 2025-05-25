TextBox = Object:extend()


function TextBox:new()

    self.active = true
    self.queuedDialogue = {}
    self.textSpeed = 10
    self.leftMargin = 100
    self.bottomMargin = 50
    self.height = lg.getHeight()/8
    self.textOffsetFromBox = 5

    self.textSpeedMaxTimer = 0.03
    self.textSpeedTimer = self.textSpeedMaxTimer

    self.activeDialogue = {}
    self.activeText = ""
    self.active = false

    self.font = love.graphics.newFont("assets/font.ttf",20)

    self.blip = love.audio.newSource("assets/blip.mp3", "stream")
    self.confirm = love.audio.newSource("assets/confirm.wav", "stream")

    self.blip:setVolume(0.05)
    self.blip:setLooping(true)
    self.blip:setPitch(4.5)

    self.confirm:setVolume(0.1)
    self.confirm:setLooping(false)


    self.confirmMaxTimer = 0.5
    self.confirmTimer = 0

    self.readyToSkip = false
end

function TextBox:queueText(_text, _name)

    local n = _name
    if(n == nil) then
        n = ""
    end

    local m = {_text, n}

    if(self.active == false) then
        self.active = true
        self.activeDialogue = m
        self.blip:play()
    else
        table.insert(self.queuedDialogue, m)
    end

end

function TextBox:keyPressed(key) 

    if(key == "space") then
        if(self.active == true) then

            if(self.readyToSkip == true) then
                self.active = false
                self.readyToSkip = false
                self.textSpeedTimer = self.textSpeedMaxTimer
                self.activeText = ""
                self.blip:stop()
                

                if(#self.queuedDialogue > 0) then
                    self.active = true
                    self.activeDialogue = self.queuedDialogue[1]
                    table.remove(self.queuedDialogue, 1)
                    self.blip:play()
                else
                    self.confirm:play()
                end

                
            else

            

                    local c = string.sub(self.activeDialogue[1],string.len(self.activeText)+1,string.len(self.activeDialogue[1]))
                    self.activeText = self.activeText .. c
                    self.readyToSkip = true
                    self.blip:stop()
                    self.confirm:stop()

                

            end
            
        end
    end

end


function TextBox:update(dt)

    
    if(self.active == true) then

        self.textSpeedTimer = self.textSpeedTimer-dt

        lg.setFont(font)
        
        if(self.textSpeedTimer < 0) then

            self.textSpeedTimer = self.textSpeedMaxTimer

            if(string.len(self.activeText) < string.len(self.activeDialogue[1])) then

                local c = string.sub(self.activeDialogue[1],string.len(self.activeText)+1,string.len(self.activeText)+1)
                self.activeText = self.activeText .. c

                if(c == " ") then
                    self.blip:stop()
                else

                    if(self.blip:isPlaying() == false) then
                        self.blip:play()
                    end

                end


            else
                self.blip:stop()
                self.readyToSkip = true
            end
        end

    end


end

function TextBox:reset()
    self.blip:stop()
    self.confirm:stop()
end

function TextBox:draw()

    lg.setFont(self.font)

    if(self.active == true) then
        local w = 3.5
        lg.setColor(love.math.colorFromBytes(84, 125, 90))
        lg.setLineWidth(w)
        love.graphics.rectangle("fill", 0+self.leftMargin ,lg.getHeight()-self.height-self.bottomMargin,lg.getWidth()-(self.leftMargin*2),self.height)
        lg.setColor(love.math.colorFromBytes(66, 92, 70))
        love.graphics.rectangle("line", self.leftMargin - (w/2) ,lg.getHeight()-self.height-self.bottomMargin- (w/2),lg.getWidth()-(self.leftMargin*2)+(w),self.height+(w))
        lg.setColor(1,1,1)
        love.graphics.printf(self.activeText, 0+self.leftMargin+self.textOffsetFromBox ,lg.getHeight()-self.height-self.bottomMargin, lg.getWidth()-(self.leftMargin*2))
    end


end


