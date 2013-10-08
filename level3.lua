--Set up the storyboard class
local storyboard = require("storyboard")
local scene = storyboard.newScene()

local mydata = require("mydata")
local physics = require("physics")

physics.start();
--physics.setDrawMode("debug");
physics.setGravity(0,0);

--Forward references so that we can access objects accross functions
local device;
local spinIt;

local lvlText
local device = {}
local ball = {}
local object = {}
local target = {}
local numOfTarget = 5
local numOfObject = 1
local score = 0
local totalCollisions = 0

mydata.lvl = 3

local function createObject()
	local view = scene.view
	local object = display.newImageRect("images/platform.png", 100, 25);
	
	function object:touch(e)
			local t = e.target
			local phase = e.phase
			
			if(e.phase == "began") then
				
				self.oldY = self.y
				self.oldX = self.x
				display.getCurrentStage():setFocus(self)
				self.hasFocus = true
				
				t.x1 = e.x
                t.y1 = e.y
				
				--print("began")
				
			elseif(self.hasFocus) then
				if(e.phase == "moved") then
					self.y = (e.y - e.yStart) + self.oldY;
					self.x = (e.x - e.xStart) + self.oldX;
					
					t.x2 = e.x
                    t.y2 = e.y
                    
                    angle1 = 180/math.pi * math.atan2(t.y1 - t.y , t.x1 - t.x)
                    angle2 = 180/math.pi * math.atan2(t.y2 - t.y , t.x2 - t.x)
                    --print("angle1 = "..angle1)
                    rotationAmt = angle1 - angle2

                    --rotate it
                    t.rotation = t.rotation - rotationAmt
                    --print ("t.rotation = "..t.rotation)
                    
                    t.x1 = t.x2
                    t.y1 = t.y2
                    
					--print("moved")
							
				elseif(e.phase == "ended" or e.phase == "cancelled") then
			
					display.getCurrentStage():setFocus(nil)
					self.hasFocus = false;
					
					--print("ended")
				end
			end
			return true
		end

	object:addEventListener("touch",object)
	view:insert(object)	
	
	return object	
end


function scene:createScene(e)
	local view = self.view	
	
	--------------Background--------------
	local background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,255);
	view:insert(background);
	--------------------------------------
	
	--------------Borders--------------
	ground = display.newRect(0,0,_W + 100,10);
	ground:setFillColor(255,156,0);
	ground.x = _W * 0.5;
	ground.y = _H + 50;
	ground.type = "ground"
	ground.collided = false
	
	ceiling = display.newRect(0,0,_W + 100,10);
	ceiling:setFillColor(255,156,0);
	ceiling.x = _W * 0.5;
	ceiling.y = - 50;
	ceiling.type = "ceiling"
	ceiling.collided = false
	
	local leftWall = display.newRect(0,0,10,_H + 100);
	leftWall:setFillColor(255,156,0);
	leftWall.x = -50;
	leftWall.y = _H * 0.5;
	leftWall.collided = false
	leftWall.type = "leftWall"
	
	local rightWall = display.newRect(0,0,10,_H + 100);
	rightWall:setFillColor(255,156,0);
	rightWall.x = _W + 50;
	rightWall.y = _H * 0.5;
	rightWall.collided = false
	rightWall.type = "rightWall"
	
	physics.addBody(ground,"static",{friction = 0.5, bounce = 1});
	physics.addBody(ceiling,"static",{friction = 0.5, bounce = 1});
	physics.addBody(leftWall,"static",{friction = 0.5, bounce = 1});
	physics.addBody(rightWall,"static",{friction = 0.5, bounce = 1});
	
	view:insert(ground);
	view:insert(ceiling);
    view:insert(leftWall);
    view:insert(rightWall);
	--------------------------------------
	
	---------------lvlText----------------
    lvlText = display.newText(string.format("Level: %1d", mydata.lvl),0,0,font,24)
    lvlText:setTextColor(0,0,0)
    lvlText.x = 50
    lvlText.y = 20
    view:insert(lvlText)
    --------------------------------------
	
	--------------scoreText---------------
	local font = "HelveticaNeue" or native.systemFont;
	levelScore = display.newText(string.format("Score: %1d", score),0,0,font,24);
    levelScore:setTextColor(0,0,0);
    levelScore.x = 50;
    levelScore.y = 40;
    view:insert(levelScore);
    --------------------------------------
    
    -----------totalCollisions------------
    collisionText = display.newText(string.format("Collisions: %1d", totalCollisions),0,0,font,24)
    collisionText:setTextColor(0,0,0)
    collisionText.x = 70
    collisionText.y = 60
    view:insert(collisionText)
    --------------------------------------
    
    --------------device------------------   
    device = display.newImageRect("images/foo.png",50,50);
	device.x = 20;
	device.y = _H *0.5;
	
	physics.addBody(device,
	{
		density = 10, friction = 0.5, bounce = 0.2, radius = 12.5,
		filter = 
		{
			categoryBits = 2, --So that the device and ball don't collide with each other
		}
	})
	
	view:insert(device)
	--------------------------------------
	
	----------------Ball------------------  
	ball = display.newImageRect("images/foo.png",25,25)
	ball.x = _W * 0.5 - 190
	ball.y = _H * 0.5
	ball.type = "ball"
	
	physics.addBody(ball,{
		density = 10, friction = 0.5, bounce = 1, radius = 12.5,
		filter = {
			categoryBits = 2, --So that the device and ball don't collide with each other
			maskBits = 1 --So that the ball collides with the ground (which is 1 by default)
		}
	})
	
	view:insert(ball)
	--------------------------------------

	----------------Objects----------------  
	for i=1 ,numOfObject do
		object[i] = createObject()
		object[i].x = _W * i/3
		object[i].y = _H * 0.5
	
		physics.addBody(object[i],"static",{density = 10, friction = 0.5, bounce = 1})
	
		view:insert(object[i]);
	end
	---------------------------------------
	
	----------------Targets----------------  
	for i=1 ,numOfTarget do
		target[i] = display.newImageRect("images/bar.png",20,20)
		target[i].x = math.random(0, _W)
		target[i].y = math.random(0, _H)
		target[i].type = "target" .. tostring(i)
		
		--print(target[i].type)
		
		physics.addBody(target[i],"static",{density = 10, friction = 0.5, bounce = 1})
		target[i].isSensor = true
		
		view:insert(target[i])
	end
	---------------------------------------
end -- end of createScene


function scene:enterScene(e)
	local view = self.view
	
	physics.start()
	
	storyboard.purgeScene("mainMeny")
	storyboard.purgeScene("reloading")
	
	
	function device:touch(e)
		if(e.phase == "began") then
			
			self.oldY = self.y
			display.getCurrentStage():setFocus(self)
			self.hasFocus = true
			
			--create a table to hold the physics joints
			pJoints = {};
			
			--Connect the device and ball together with a weld joint
			pJoints[1] = physics.newJoint("weld", device, ball, device.x, device.y);
			device.isFixedRotation = true;
				
			--print("began")
			
		elseif(self.hasFocus) then
			if(e.phase == "moved") then
				--move the device in y-axis
				self.y = (e.y - e.yStart) + self.oldY;
				
				--print("moved")
						
			elseif(e.phase == "ended" or e.phase == "cancelled") then
				
				--To remove a joint, call its removeSelf method
				pJoints[1]:removeSelf()
				
				-- set velocity to the ball on the x-axis
				ball:setLinearVelocity(300,0)
				
				-- damp the device and make it invisible
				device.linearDamping = 1000
				device.isVisible = false
				
				display.getCurrentStage():setFocus(nil)
				self.hasFocus = false;
				
				--print("ended")	
			end
		end
		return true
	end
	device:addEventListener("touch",device)
	
	
	function onCollision(self, e)
	 	if ( e.phase == "began" ) then
			totalCollisions = totalCollisions + 1
			collisionText.text = "Collisions: " .. totalCollisions
		end
	 	
	 	for i=1 ,numOfTarget do	
			
			if e.target.type == "ball" and e.other.type == "ground" or e.other.type == "rightWall" or
			e.other.type == "leftWall" or e.other.type == "ceiling" then

				timer.performWithDelay(20, restart)
				
			elseif e.target.type == "ball" and e.other.type == "target" .. tostring(i)  then
				target[i]:removeSelf()	
				score = score + 1
				levelScore.text = "Score: " .. score
			end
		end
	   
		if score >= 3 then
		
			if mydata.lvlUnlocked <= mydata.lvl then
				mydata.lvlUnlocked = 4
			end
			
			lvlText.text = string.format("Level: %1d", mydata.lvl)
			timer.performWithDelay(20, nextLevel)
		end
	end
	
	ball.collision = onCollision
	ball:addEventListener("collision", ball)
	
	function restart()
		storyboard.gotoScene("reloading", {time =250, effect="crossFade"})
		--print("restarting")
	end
	
	function nextLevel()
		storyboard.removeScene("nextLevel")
		storyboard.gotoScene("nextLevel", {time =250, effect="crossFade"})
		--print("next level")
	end

end -- end of enterScene


function scene:exitScene(e)
	local view = self.view
	
	--Stop listeners, timers, and animations (transitions)
	ball:removeEventListener("collision", ball)
	device:removeEventListener("touch",device)
	physics.stop()
end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);

return scene