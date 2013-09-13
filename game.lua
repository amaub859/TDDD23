--requires

local physics = require "physics"
physics.start()

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

--Background

function scene:createScene(event)

	local screenGroup = self.view
	
	local background = display.newImage("bkg_clouds.png")
	screenGroup:insert(background) 

	ground = display.newImage("ground.png") 
	ground:setReferencePoint(display.bottomLeftReferencePoint)
	ground.x = 160
	ground.y = 450
	ground.speed = 2
	screenGroup:insert(ground) 

	ground2 = display.newImage("ground.png") 
	ground2:setReferencePoint(display.bottomLeftReferencePoint)
	ground2.x = 480
	ground2.y = 450
	ground2.speed = 2
	screenGroup:insert(ground2) 
	
	box = display.newImage("red_balloon.png") 
	box.x = 50
	box.y = -100
	physics.addBody(box, "dynamic", {density=.1, bounce=0.1, friction=.2, radious=12})
	screenGroup:insert(box)
	
	boulder = display.newImage("boulder.png") 
	boulder.x = 400
	boulder.y = 200
	boulder.speed = math.random(2,6)
	boulder.initY = boulder.y
	boulder.amp = math.random(20,200)
	boulder.angle = math.random(1,360)
	physics.addBody(boulder, "static", {density=0.1, bounce=0.1, friction=0.2, radious=12})
	screenGroup:insert(boulder)  

end


function scrollGround(self,event)
	if	self.x < -157 then
		self.x = 480
	else
		self.x = self.x - self.speed
	end
end

function moveBoulders(self,event)
	if	self.x < -157 then
		self.x = 480
		self.y = math.random(90,220)
		self.speed = math.random(2,6)
		self.amp = math.random(20,200)
		self.angle = math.random(1,360)
	else
		self.x = self.x - self.speed
		self.angle = self.angle + 0.1
		self.y = self.amp * math.sin(self.angle)+self.initY
	end
end


function activateBox(self,event)
	self:applyForce(0, -20, self.x, self.y)
end

function touchScreen(event)
	--print("touch")
	if	event.phase == "began" then
		box.enterFrame = activateBox
		Runtime:addEventListener("enterFrame", box)
		print("began")
	end
	
	if 	event.phase == "ended" then
		Runtime:removeEventListener("enterFrame", box)
		print("ended")
	end
	
end


function scene:enterScene(event)

	ground2.enterFrame = scrollGround
	Runtime:addEventListener("enterFrame", ground2)

	ground.enterFrame = scrollGround
	Runtime:addEventListener("enterFrame", ground)
	
	boulder.enterFrame = moveBoulders
	Runtime:addEventListener("enterFrame", boulder)
	
	Runtime:addEventListener("touch", touchScreen)

end

function scene:exitScene(event)

end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene


