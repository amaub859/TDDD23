--Set up the storyboard class
local storyboard = require("storyboard")
local scene = storyboard.newScene()

local mydata = require("mydata")
local physics = require("physics")

physics.start();
--physics.setDrawMode("debug");
physics.setScale( 60 ) 
physics.setGravity(0,0)

--Forward references so that we can access objects accross functions
local device;
local spinIt;

local lvlText
local device = {}
local ball = {}
local pJoints = {}
local dynamicObject = {}
local staticObject = {}
local target = {}
local lvlComplete = nil
local numOfTarget = 3
local numOfDynamicObject = 2
local numOfStaticObject = 1

mydata.lvl = 3


------------Functions------------ 

local function onButtonNext(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, nextLevel)
	end
	return true
end


local function onButtonHome(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, home)
	end
	return true
end


local function onButtonRestart(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, restart)
	end
	return true
end


local function spawnTargets()
	local view = scene.view
	
	local trgt = display.newImageRect("images/bar.png",20,20)
	
	physics.addBody(trgt,"static",{density = 10, friction = 0.5, bounce = 1})
	trgt.isSensor = true
	
	view:insert(trgt)
	return trgt

end


local function levelComplete()
	local view = scene.view
	
	local frameGroup = display.newGroup()
	
	local frame = display.newImageRect("images/background_sky.png",300,200)
	local frameText = display.newText("Level Completed", 0, 0, native.systemFont, 24)
	frameText:setTextColor(0,0,0)
	
	star1 = display.newImageRect("images/star.png",50,50)
	local star1Unlocked = display.newImageRect("images/star2.png",50,50)
	star2 = display.newImageRect("images/star.png",50,50)
	local star2Unlocked = display.newImageRect("images/star2.png",50,50)
	star3 = display.newImageRect("images/star.png",50,50)
	local star3Unlocked = display.newImageRect("images/star2.png",50,50)

	buttonNext = display.newImageRect("images/btn_arrow.png",40,40)
	buttonNext:addEventListener("touch",onButtonNext)
	
	buttonHome = display.newImageRect("images/btn_arrow.png",40,40)
	buttonHome:addEventListener("touch",onButtonHome)
	
	buttonRestart = display.newImageRect("images/btn_arrow.png",40,40)
	buttonRestart:addEventListener("touch",onButtonRestart)

	frameText.x = 0
	frameText.y = -80
	
	star3.x = 80
	star3.y = 0
	
	star3Unlocked.x = 80
	star3Unlocked.y = 0
	
	star1.x = -80
	star1.y = 0
	
	star1Unlocked.x = -80
	star1Unlocked.y = 0

	buttonNext.x = 80
	buttonNext.y = 80
	
	buttonHome.x = -80
	buttonHome.y = 80
	
	buttonRestart.x = 0
	buttonRestart.y = 80
	
	frameGroup:insert(frame)
	frameGroup:insert(frameText)
	frameGroup:insert(star1Unlocked)
	frameGroup:insert(star2Unlocked)
	frameGroup:insert(star3Unlocked)
	frameGroup:insert(star1)
	frameGroup:insert(star2)
	frameGroup:insert(star3)

	frameGroup:insert(buttonNext)
	frameGroup:insert(buttonHome)
	frameGroup:insert(buttonRestart)
	
	view:insert(frameGroup)
	
	return frameGroup
	
end

	
local function createDynamicObject()
	local view = scene.view
	local dynamicObject = display.newImageRect("images/platform.png", 100, 25);
	
	function dynamicObject:touch(e)
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

	dynamicObject:addEventListener("touch",dynamicObject)
	view:insert(dynamicObject)	
	
	return dynamicObject	
end
---------------------------------------


function scene:createScene(e)
	local view = self.view	
	
	--------------Background--------------
	local background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,255);
	view:insert(background);
	--------------------------------------
	
	---------------Borders----------------
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
	
	leftWall = display.newRect(0,0,10,_H + 100);
	leftWall:setFillColor(255,156,0);
	leftWall.x = -50;
	leftWall.y = _H * 0.5;
	leftWall.collided = false
	leftWall.type = "leftWall"
	
	rightWall = display.newRect(0,0,10,_H + 100);
	rightWall:setFillColor(255,156,0);
	rightWall.x = _W + 50;
	rightWall.y = _H * 0.5;
	rightWall.collided = false
	rightWall.type = "rightWall"
	
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
	levelScore = display.newText(string.format("Score: %1d", mydata.score),0,0,font,24);
    levelScore:setTextColor(0,0,0);
    levelScore.x = 50;
    levelScore.y = 40;
    view:insert(levelScore);
    --------------------------------------
    
    -----------totalCollisions------------
    collisionText = display.newText(string.format("Collisions: %1d", mydata.collision),0,0,font,24)
    collisionText:setTextColor(0,0,0)
    collisionText.x = 70
    collisionText.y = 60
    view:insert(collisionText)
    --------------------------------------
    
    --------------device------------------   
    device = display.newImageRect("images/foo.png",50,50);
	device.x = 20;
	device.y = _H *0.5;
	view:insert(device)
	--------------------------------------
	
	----------------Ball------------------  
	ball = display.newImageRect("images/foo.png",25,25)
	ball.type = "ball"
	view:insert(ball)
	--------------------------------------
	
	-----------staticObjects-------------  
	for i=1 ,numOfStaticObject do
		staticObject[i] = display.newImageRect("images/platform.png", 200, 25);
		if i == 1 then
			staticObject[i].x = _W * 0.5
			staticObject[i].y = _H 
		elseif i == 2 then	
			staticObject[i].x = _W * 0.5
			staticObject[i].y = 0
		end
		view:insert(staticObject[i]);
	end
	---------------------------------------
	
end -------------------------------------------- end of createScene


function scene:willEnterScene(e)
	local view = self.view
	
	physics.start()
	physics.setGravity(0,0)
	
	------------Reloading positions-------------
	device.isVisible = true
	device.x = 20
	device.y = _H *0.5
	
	ball.x = _W * 0.5 - 190
	ball.y = _H * 0.5
	--------------------------------------------

	-------------Add Physic Bodies--------------
	physics.addBody(ground,"static",{friction = 0.5, bounce = 1});
	physics.addBody(ceiling,"static",{friction = 0.5, bounce = 1});
	physics.addBody(leftWall,"static",{friction = 0.5, bounce = 1});
	physics.addBody(rightWall,"static",{friction = 0.5, bounce = 1});
	
	physics.addBody(device,{
		density = 10, friction = 0.5, bounce = 0.2, radius = 12.5,
		filter = 
		{
			categoryBits = 2, --So that the device and ball don't collide with each other
			maskBits = 1 --So that the ball collides with the ground (which is 1 by default)
		}
	})
	
	physics.addBody(ball,{
		density = 10, friction = 0.5, bounce = 1, radius = 12.5,
		filter = {
			categoryBits = 2, --So that the device and ball don't collide with each other
			maskBits = 1 --So that the ball collides with the ground (which is 1 by default)
		}
	})
	
	for i=1 ,numOfStaticObject do
		physics.addBody(staticObject[i],"static",{density = 10, friction = 0, bounce = 1})
	end
	---------------------------------------------
	
	pJoints[1] = physics.newJoint("weld", device, ball, device.x, device.y)
	device.isFixedRotation = true
end -------------------------------------------- end of willEnterScene


function scene:enterScene(e)
	local view = self.view
	
	storyboard.purgeScene("mainMeny")
	storyboard.purgeScene("reloading")
	
	---------------Create Targets----------------  
	for i=1 ,numOfTarget do
		target[i] = spawnTargets()
		target[i].x = _W * i/5
		target[i].y = _H * 0.5
		target[i].type = "target" .. tostring(i)
	end
	---------------------------------------------
	
	-----------Create dynamicObjects-------------  
	for i=1 ,numOfDynamicObject do
		dynamicObject[i] = createDynamicObject()
		dynamicObject[i].x = _W * i/3
		dynamicObject[i].y = _H * 0.5
	end
	---------------------------------------------
	
	---------Create levelComplete frame---------- 
	lvlComplete = levelComplete()
	lvlComplete.x = _W *0.5
	lvlComplete.y = _H *0.5
	lvlComplete.alpha = 0
	---------------------------------------------
	
	function device:touch(e)
		if(e.phase == "began") then
			
			self.oldY = self.y
			display.getCurrentStage():setFocus(self)
			self.hasFocus = true
			
		elseif(self.hasFocus) then
			if(e.phase == "moved") then
				--move the device in y-axis
				self.y = (e.y - e.yStart) + self.oldY;
				
				if self.y < 0 then
					self.y = 0
				elseif self.y > _H then
					self.y = _H
				end
				--print("moved")
						
			elseif(e.phase == "ended" or e.phase == "cancelled") then
				display.getCurrentStage():setFocus(nil)
				self.hasFocus = false;
				
				--print("ended")	
			end
		end
		return true
	end
	device:addEventListener("touch",device)
	
	
	function shootBall(e)
		local view = scene.view
		local t = e.target
		local phase = e.phase
		
		if "began" == phase then
			display.getCurrentStage():setFocus(t)
			t.isFocus = true
			
			----------Create Rotating aim------------
			aim = display.newImage( "images/aim.png" )
			aim.x = ball.x; aim.y = ball.y; aim.alpha = 0;
			
			aim.x = t.x
			aim.y = t.y
			view:insert(aim)
			
			startRotation = function()
			
				aim.rotation = aim.rotation + 4
			end
		
			Runtime:addEventListener( "enterFrame", startRotation )
			
			local showTarget = transition.to( aim, { alpha=0.4, xScale=0.25, yScale=0.25, time=200 } )
			---------------------------------------------
			
			--To remove a joint, call its removeSelf method
			pJoints[1]:removeSelf()
			
			myLine = nil
			ball.isFixedRotation = true

			
		elseif t.isFocus then
			if "moved" == phase then
				if (myLine) then
					myLine.parent:remove( myLine ) -- erase previous line, if any
				end
				
				---------------Create Line----------------
				if mydata.deviceUnlocked == 2 then
					myLine = display.newLine( t.x,t.y, e.x,e.y )
				else
					myLine = display.newLine( t.x,0, e.x,0 )
					myLine.y = t.y
				end
				myLine:setColor( 255, 0, 0, 50 )
				myLine.width = 10
				view:insert(myLine)
				---------------------------------------------
				
			elseif "ended" == phase or "cancelled" == phase then
			
				display.getCurrentStage():setFocus(nil)
				t.isFocus = false
				
				--Remove aim and Line
				local stopRotation = function()
					Runtime:removeEventListener("enterFrame", startRotation)
					aim.parent:remove(aim)
					aim = nil
				end
				
				local hideAim = transition.to( aim, { alpha=0.4, xScale=1.0, yScale=1.0, time=200,onComplete=stopRotation } )
				
				if (myLine) then
					myLine.parent:remove( myLine )
				end
				
				device:setLinearVelocity(-20,0)
				
				-- add physic body to the dynamic objects
				for i=1 ,numOfDynamicObject do
					physics.addBody(dynamicObject[i],"static",{density = 10, friction = 0.5, bounce = 1})
					-- Remove event listeners for the dynamic objects
					dynamicObject[i]._tableListeners = nil
				end
				
				--local cueShot = audio.loadSound("cueShot.mp3")
				--audio.play(cueShot)
				if mydata.deviceUnlocked == 2 then
					t:applyForce( (t.x - e.x)*5, (t.y - e.y)*5, t.x*5, t.y*5 )
				else	
					t:applyForce( (t.x - e.x)*5, (0), t.x*5, 0 )
				end	
					
				ball:removeEventListener( "touch", shootBall )
			end
		end
		return true	-- Stop further propagation of touch event
	end
	ball:addEventListener( "touch", shootBall ) -- Sets event listener to ball
	
	
	
	function onCollision(self, e)
	 	if ( e.phase == "began" ) then
			mydata.collision  = mydata.collision  + 1
			collisionText.text = "Collisions: " .. mydata.collision 
			ball.isFixedRotation = false
		end
	 	
	 	for i = numOfTarget, 1, -1 do
			
			if e.target.type == "ball" and e.other.type == "ground" or e.other.type == "rightWall" or
			e.other.type == "leftWall" or e.other.type == "ceiling" then

				timer.performWithDelay(20, reload)
				
			elseif e.target.type == "ball" and e.other.type == "target" .. tostring(i)  then
				display.remove(target[i])
				target[i] = nil
				mydata.score = mydata.score + 1
				levelScore.text = "Score: " .. mydata.score
			end
		end
	   
		if mydata.score >= 3 then
			
			lvlComplete.alpha = 1
			star1.alpha = 0
			ball.linearDamping = 5
			
			------------Possible Stars--------------
			local bool = false
			for i=1,#mydata.star do
				if mydata.star[i] == "star7" then
					bool = true
				end
			end
			if bool == false then
				table.insert(mydata.star, "star7")
			end
			
			if mydata.reload < 2 then
				local bool = false
				star2.alpha = 0
				for i=1,#mydata.star do
					if mydata.star[i] == "star8" then
						bool = true
					end
				end
				if bool == false then
					table.insert(mydata.star, "star8")
				end
			end
			
			if mydata.collision < 10 then
				local bool = false
				star3.alpha = 0
				for i=1,#mydata.star do
					if mydata.star[i] == "star9" then
						bool = true
					end
				end
				if bool == false then
					table.insert(mydata.star, "star9")
				end
			end
			print(#mydata.star)
			---------------------------------------
			
			if mydata.lvlUnlocked <= mydata.lvl then
				mydata.lvlUnlocked = 4
			end	
		end
	end
	ball.collision = onCollision
	ball:addEventListener("collision", ball)
	
	
	function removeTarget(target)
		for i = #target, 1, -1 do
			if(target[i] == i) then
				table.remove(target,i)
				target[i]:removeSelf()
				break
			end
		end
	end
	
	
	function reload()
		storyboard.gotoScene("reloading", {time =250, effect="crossFade"})
	end
	
	
	function restart()
		mydata.score = 0
		mydata.reload = 0
		mydata.collision = 0
		storyboard.reloadScene() 
	end
	
	
	function nextLevel()
		storyboard.removeScene("nextLevel")
		storyboard.gotoScene("nextLevel", {time =250, effect="crossFade"})
	end
	
	
	function home()
		storyboard.removeScene("mainMeny")
		storyboard.removeScene("nextLevel")
		storyboard.gotoScene("mainMeny", {time =250, effect="crossFade"})
	end

end ---------------------------------------------- end of enterScene


function scene:exitScene(e) --Stop listeners, timers, and animations (transitions)
	local view = self.view
	
	for i = numOfDynamicObject, 1, -1 do
		physics.removeBody(dynamicObject[i])
		display.remove(dynamicObject[i])
		dynamicObject[i] = nil
	end
	
	for i = numOfStaticObject, 1, -1 do
		physics.removeBody(staticObject[i])
	end
	
	levelScore.text = string.format("Score: %1d", 0)
	collisionText.text = string.format("Collisions: %1d", 0)
	
	ball:removeEventListener("collision", ball)
	
	lvlComplete.alpha = 0
	--ball:removeEventListener("collision", ball)
	--device:removeEventListener("touch",device)
	physics.stop()
end ---------------------------------------------- end of exitScene

scene:addEventListener("createScene", scene);
scene:addEventListener("willEnterScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);

return scene