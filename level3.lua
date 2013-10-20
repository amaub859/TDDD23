--Set up the storyboard class
local storyboard = require("storyboard")
local scene = storyboard.newScene()

local mydata = require("mydata")
local physics = require("physics")

physics.start();
--physics.setDrawMode("debug");
physics.setScale( 60 ) 
physics.setGravity(0,0)

------------------Sound effects------------------- 
local soundEffects = {

	 boingSound = audio.loadSound("sound/boing_wav.wav"),
	 aimSound = audio.loadSound("sound/aim.mp3"),
	 getTarget = audio.loadSound("sound/getTarget.mp3"),
	 shotSound = audio.loadStream("sound/shot.mp3")
}

mydata.lvlMusic = audio.loadStream("sound/levelStart.mp3")
--------------------------------------------------

--Forward references so that we can access objects accross functions
local device;
local spinIt;

local textGroup
local device = {}
local ball = {}
local pJoints = {}
local dynamicObject = {}
local staticObject = {}
local movingObject = {}
local target = {}
local gravityTarget = {}
local lvlComplete = nil
local numOfTarget = 3
local numOfDynamicObject = 1
local numOfStaticObject = 3
local numOfMovingObject = 3
local numOfGravityTarget = 0
local anim

local lvlShots = 2
local lvlCollisions = 6
local lvlMonsters = 3
mydata.lvl = 3
local lvlNext = 4
local lvlStar1 = "star7"
local lvlStar2 = "star8"
local lvlStar3 = "star9"

local myFont = (platform ~= "Android") and "Manteka" or system.nativeFont;

------------Functions------------ 

local function onButtonNext(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, nextLevel)
	end
	return true
end


local function onButtonHome(e)
	if e.phase == "ended" then
		audio.stop(1)
		audio.dispose(mydata.startMusic)
		mydata.startMusic = nil
		
		timer.performWithDelay(20, home)
	end
	return true
end


local function onReloadBtn(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, reload)
	end
	return true
end


local function onRestartBtn(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, restart)
	end
	return true
end


local function onInfoBtn(e)
	if e.phase == "ended" then
		levelInfo()
	end
	return true
end


local function onBtnShop(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, goToShop)
	end
	return true
end


local function onBackgroundTouch(e)
	if e.phase == "ended" then
		frameGroup.alpha = 0
	end
	return true
end

local function spawnTargets()
	local view = scene.view
	
	local trgt = display.newImageRect("images/spaceMonster.png",25,25)
	
	physics.addBody(trgt,"static",{density = 10, friction = 0.5, bounce = 1})
	trgt.isSensor = true
	
	return trgt

end


local function spawnGravityTargets()
	local view = scene.view
	
	local trgt = display.newImageRect("images/foo.png",20,20)
	
	physics.addBody(trgt,"static",{density = 10, friction = 0.5, bounce = 1})
	trgt.isSensor = true
	
	return trgt

end


local function levelComplete()
	local view = scene.view
	
	local frameGroup = display.newGroup()
	
	local frame = display.newImageRect("images/background_sky.png",300,200)
	local blackFrame = display.newRect(0, 0, _W, _H);
	blackFrame:setFillColor(0,0,0);
	local frameText = display.newText("Level Completed!", 0, 0, myFont, 24)
	frameText:setTextColor(255,156,0)
	
	star1 = display.newImageRect("images/star2.png",50,50)
	star2 = display.newImageRect("images/star2.png",50,50)
	star3 = display.newImageRect("images/star2.png",50,50)
	
	local textOptions = { text = "All monsters", x = -80, y = 30, width = 64, align = "center", font = myFont, fontSize = 10 }
    star1Txt = display.newText(textOptions)
    star1Txt:setTextColor(244,204,34)
	
	local textOptions = { text = "", x = 0, y = 10, width = 36, align = "center", font = myFont, fontSize = 10 }
    star2Txt = display.newText(textOptions)
    star2Txt:setTextColor(244,204,34)
    
    local textOptions = { text = "", x = 80, y = 30, width = 64, align = "center", font = myFont, fontSize = 10 }
    star3Txt = display.newText(textOptions)
    star3Txt:setTextColor(244,204,34)

	buttonNext = display.newImageRect("images/nextBtn.png",40,40)
	buttonNext:addEventListener("touch",onButtonNext)
	buttonNext.alpha = 0
	
	buttonHome = display.newImageRect("images/homeBtn.png",40,40)
	buttonHome:addEventListener("touch",onButtonHome)
	
	restartBtn = display.newImageRect("images/buttonRestart.png",40,40)
	restartBtn:addEventListener("touch",onRestartBtn)
	
	btnShop = display.newImageRect("images/shopBtn.png",40,40)
	btnShop:addEventListener("touch",onBtnShop)

	frameText.x = 0
	frameText.y = -80
	
	blackFrame.x = 0
	blackFrame.y = 0	
	blackFrame.alpha = 0.5
	
	star3.x = 80
	star3.y = -10
	star3.alpha = 0.2
	
	star1.x = -80
	star1.y = -10
	star1.alpha = 0.2
	
	star2.x = 0
	star2.y = -30
	star2.alpha = 0.2

	buttonNext.x = 80
	buttonNext.y = 80
	
	buttonHome.x = -80
	buttonHome.y = 80
	
	restartBtn.x = 0
	restartBtn.y = 80
	
	btnShop.x = -140
	btnShop.y = -50
	
	frameGroup:insert(frame)
	frameGroup:insert(blackFrame)
	frameGroup:insert(frameText)
	frameGroup:insert(star1)
	frameGroup:insert(star2)
	frameGroup:insert(star3)
	frameGroup:insert(star1Txt)
	frameGroup:insert(star2Txt)
	frameGroup:insert(star3Txt)

	frameGroup:insert(buttonNext)
	frameGroup:insert(buttonHome)
	frameGroup:insert(restartBtn)
	frameGroup:insert(btnShop)
	
	view:insert(frameGroup)
	
	return frameGroup
	
end


function levelInfo()
	local view = scene.view
	
	frameGroup = display.newGroup()
	
	local background = display.newRect(0, 0, _W, _H)
	local frame = display.newImageRect("images/background_sky.png",300,200)
	local frameText = display.newText("Level Mission:", 0, 0, native.systemFont, 24)
	local frameText2 = display.newText("* All monster in " .. lvlShots .. " shots", 0, 0, myFont, 20)
	
	background:setFillColor(0,0,0)
	background.alpha = 0.2
	background.x = 0	
	background.y = 0
	background:addEventListener("touch",onBackgroundTouch)
	
	frame.x = 0
	frame.y = 0
	
	frameText:setTextColor(255,156,0)
	frameText.x = 0
	frameText.y = -80
	
	frameText2:setTextColor(255,156,0)
	frameText2.x = 0
	frameText2.y = 0
	
	frameGroup:insert(background)
	frameGroup:insert(frame)
	frameGroup:insert(frameText)
	frameGroup:insert(frameText2)
	
	view:insert(frameGroup)
	
	frameGroup.x = _W * 0.5;
	frameGroup.y = _H * 0.5;
	
	return frameGroup
	
end

	
local function createDynamicObject()
	local view = scene.view
	local dynamicObject = display.newImageRect("images/astroids.png", 100, 25);
	
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
	
	return dynamicObject	
end
---------------------------------------


function scene:createScene(e)
	local view = self.view	
	
	audio.fade( { channel=1, time=2000, volume=0 } )
	--audio.stopWithDelay(2000,{channel= 1})
	
	--audio.seek(280000, mydata.lvlMusic)
	--audio.play(mydata.lvlMusic, {channel=7, loops=0,fadein=14000})
	--audio.setVolume(0.2, {channel = 1})
	
	--------------Background--------------
	local background = display.newImageRect("images/lvlBackground" .. mydata.lvl .. ".png",_W,_H)
	background.x = _W * 0.5;
	background.y = _H * 0.5;
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
	
	---------------textGroup----------------
	textGroup = display.newGroup()
	
    lvlText = display.newText(string.format("Level %1d", mydata.lvl),0,0,myFont,24)
    lvlText:setTextColor(255,156,0)
    lvlText.x = 0
    lvlText.y = 0
    
    missionText = display.newText("All monster in " .. lvlShots .. " shots", 0, 0, myFont, 24)
    missionText:setTextColor(255,156,0)
    missionText.x = 0
    missionText.y = 30
    
    textGroup:insert(lvlText)
    textGroup:insert(missionText)
    
    textGroup.x = _W * 0.5
    textGroup.y = _H * 0.3
   
    view:insert(textGroup)
    --------------------------------------
    
	
	-----------staticObjects--------------  
	for i=1 ,numOfStaticObject do
		staticObject[i] = display.newImageRect("images/staticObject.png", 200, 25);
		if i == 1 then
			staticObject[i].x = _W * 0.5
			staticObject[i].y = _H 
		elseif i == 2 then	
			staticObject[i].x = _W * 0.5
			staticObject[i].y = 0
		elseif i == 3 then		
			staticObject[i].x = _W
			staticObject[i].y = _H * 0.5
			staticObject[i]:rotate(90)
		end
		staticObject[i].type = "staticObject"
		view:insert(staticObject[i]);
	end
	---------------------------------------
	
	--------------scoreText---------------
	local textOptions = { text = "Score: " .. mydata.score, x = 110, y = 15, width = 200, align = "left", font = myFont, fontSize = 12 }
	levelScore = display.newText(textOptions);
    levelScore:setTextColor(244,204,34);
    levelScore.alpha = 0.8
    view:insert(levelScore);
    --------------------------------------
    
    -----------totalShots------------
    local textOptions = { text = "Shots: " .. mydata.collision, x = 110, y = 30, width = 200, align = "left", font = myFont, fontSize = 12 }
    lvlShotsTxt = display.newText(textOptions)
    lvlShotsTxt:setTextColor(244,204,34)
    lvlShotsTxt.alpha = 0.8
    view:insert(lvlShotsTxt)
    --------------------------------------
    
    -----------totalCollisions------------
    local textOptions = { text = "Collisions: " .. mydata.collision, x = 110, y = 45, width = 200, align = "left", font = myFont, fontSize = 12 }
    collisionText = display.newText(textOptions)
    collisionText:setTextColor(244,204,34)
    collisionText.alpha = 0.8
    view:insert(collisionText)
    --------------------------------------
	
	--------------Game Buttons-------------
	infoBtn = display.newImageRect("images/infoBtn.png",40,40)
	infoBtn.x = 25
	infoBtn.y = _H - 25 
	infoBtn.alpha = 0.8
	infoBtn:addEventListener("touch",onInfoBtn)
	view:insert(infoBtn)
	
	reloadBtn = display.newImageRect("images/buttonRestart.png",40,40)
	reloadBtn.x = 75
	reloadBtn.y = _H - 25 
	reloadBtn.alpha = 0.8
	reloadBtn:addEventListener("touch",onReloadBtn)
	view:insert(reloadBtn)
	
	homeBtn = display.newImageRect("images/homeBtn.png",40,40)
	homeBtn.x = _W - 25
	homeBtn.y = 25
	homeBtn.alpha = 0.8
	homeBtn:addEventListener("touch",onButtonHome)
	view:insert(homeBtn)
	
	starGroup = display.newGroup()
	local font = "HelveticaNeue" or native.systemFont;
	starTxt = display.newText(string.format("%1dx", #mydata.star),0,0,font,15);
	starTxt:setTextColor(244,204,34)
	starTxt.x = _W - 10
	starTxt.y = _H - 10
	
	starsPic = display.newImageRect("images/star2.png",20,20)
	starsPic.x = _W - 30
	starsPic.y = _H - 15
	
	starGroup:insert(starsPic)
	starGroup:insert(starTxt)
	starGroup.alpha = 0.8
	view:insert(starGroup)
	---------------------------------------
	
end -------------------------------------------- end of createScene


function scene:willEnterScene(e)
	local view = self.view
	
	physics.start()
	physics.setGravity(0,0)
	
	infoBtn.alpha = 0.8
	reloadBtn.alpha = 0.8
	homeBtn.alpha = 0.8
	
	----------------Create Ball-----------------
	function resetBall()
		ball = display.newImageRect("images/astroid.png",25,25)
		ball.type = "ball"
		ball.x = 75
		ball.y = _H * 0.5
		
		physics.addBody(ball,"kinematic",{
			density = 10, friction = 0.5, bounce = 1, radius = 12.5,
			filter = {
				categoryBits = 2, --So that the device and ball don't collide with each other
				maskBits = 1 --So that the ball collides with the ground (which is 1 by default)
			}
		})
		ball.isSensor = true
		
		view:insert(ball)
	end
	resetBall()
	--------------------------------------------
	
	---------------Create Device----------------
	function resetDevice()
		if mydata.deviceUnlocked == 2 then
			device = display.newImageRect("images/device2.png",65,40);
		else
			device = display.newImageRect("images/device.png",65,40);
		end
		device.x = 35;
		device.y = _H *0.5;
		
		physics.addBody(device,"kinematic",{
		density = 10, friction = 0.5, bounce = 0.2, radius = 12.5,
			filter = 
			{
				categoryBits = 2, --So that the device and ball don't collide with each other
				maskBits = 1 --So that the ball collides with the ground (which is 1 by default)
			}
		})
		device.isSensor = true
		
		function device:touch(e)
			if(e.phase == "began") then
				
				self.oldY = self.y
				display.getCurrentStage():setFocus(self)
				self.hasFocus = true
				
				device.isFixedRotation = true
				
			elseif(self.hasFocus) then
				if(e.phase == "moved") then
					--move the device in y-axis
					self.y = (e.y - e.yStart) + self.oldY;
					
					if self.y < 0 then
						self.y = 0
					elseif self.y > _H then
						self.y = _H
					end
					
					ball.y = self.y
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
		
		view:insert(device)
	end	
	resetDevice()
	--------------------------------------------
	
	---------------Create Targets---------------- 
	if mydata.time ~= 0 then 
		for i=1 ,numOfTarget do
			target[i] = spawnTargets()
			if i == 1 then
				target[i].x = _W * 0.5
				target[i].y = _H * 0.5
			elseif i == 2 then	
				target[i].x = _W * 0.5
				target[i].y = _H * 0.2	
			elseif i == 3 then	
				target[i].x = _W * 0.7
				target[i].y = _H * 0.7	
			end
			target[i].type = "target" .. tostring(i)
			view:insert(target[i])
		end
	end
	---------------------------------------------
	
	---------------Create Gravity Targets----------------  
	for i=1 ,numOfGravityTarget do
		gravityTarget[i] = spawnGravityTargets()
		gravityTarget[i].x = _W * i/5
		gravityTarget[i].y = _H * 0.3
		gravityTarget[i].type = "gravityTarget" .. tostring(i)
		view:insert(gravityTarget[i])
	end
	---------------------------------------------
	
	-----------Create dynamicObjects-------------  
	for i=1 ,numOfDynamicObject do
		dynamicObject[i] = createDynamicObject()
		dynamicObject[i].x = _W * 0.8
		dynamicObject[i].y = _H * 0.1 + (i * 120)
		dynamicObject[i].type = "dynamicObject"
		view:insert(dynamicObject[i])
	end
	---------------------------------------------
	
	------------Create movingObject--------------  
	--print(mydata.reload)
		for i=1 ,numOfMovingObject do
			movingObject[i] = display.newImageRect("images/staticObject.png", 100, 15);
			if i == 1 then
				movingObject[i].x = _W * 0.4
				movingObject[i].y = _H * 0.2
				movingObject[i]:rotate(90)
			elseif i == 2 then	
				movingObject[i].x = _W * 0.5
				movingObject[i].y = _H * 0.4
			elseif i == 3 then	
				movingObject[i].x = _W * 0.6
				movingObject[i].y = _H * 0.2
				movingObject[i]:rotate(90)	
			end
			movingObject[i].type = "movingObject"
			physics.addBody(movingObject[i],"dynamic",{density = 10, friction = 0, bounce = 1})
			view:insert(movingObject[i])
		end
	--------------------------------------------
	
	-------------- Create Level Timer--------------
	if mydata.time ~= 0 then
		output = display.newText("" .. mydata.time, 0, 0, native.systemFont, 20);
		output:setTextColor(244,204,34);
		output:setReferencePoint(display.CenterReferencePoint)
		output.x = _W * 0.97;
		output.y = _H * 0.9;
		
			-- Create a method to add the setText method to text objects
		local function addSetText(obj)
			-- Create a custom method for setting text
			function obj:setText(txt,align)
				local a = align or display.CenterReferencePoint;
				local oldX = self.x;
				local oldY = self.y;
				self.text = txt;
				self:setReferencePoint(a);
				self.x = oldX;
				self.y = oldY;
			end
		end
		
		-- Add the setText method to the two text objects
		addSetText(output);
			
			--Assign a timer to the variable
		tmr = timer.performWithDelay(1000, function(e)
			mydata.time = mydata.time - 1
			--print(mydata.time)
			output:setText(mydata.time, display.CenterReferencePoint);
			if output.alpha > 0 then
				output.alpha = math.round((output.alpha - 0.25) * 10)*0.1
			end
			--print(mydata.time - e.count)
		
			if(mydata.time == 5) then
				output.alpha = 1
			elseif(mydata.time == 0) then
			
				timer.cancel(tmr);
				tmr = nil;
				for i=1 ,numOfTarget do
					if target[i] ~= nil then
						display.remove(target[i])
						target[i] = nil
					end
				end
			end
		end,60);--rate of timer, callback function, # of iterations
	end
	------------------------------------------
	
	-------Bring play bottoms toFront----------
	infoBtn:toFront()
	reloadBtn:toFront()
	homeBtn:toFront()
	collisionText:toFront()
	levelScore:toFront()
	lvlShotsTxt:toFront()
	starGroup:toFront()
	textGroup:toFront()
	--------------------------------------------

	-------------Add Physic Bodies--------------
	physics.addBody(ground,"kinematic",{friction = 0.5, bounce = 1});
	physics.addBody(ceiling,"kinematic",{friction = 0.5, bounce = 1});
	physics.addBody(leftWall,"kinematic",{friction = 0.5, bounce = 1});
	physics.addBody(rightWall,"kinematic",{friction = 0.5, bounce = 1});
	ground.isSensor = true
	ceiling.isSensor = true
	leftWall.isSensor = true
	rightWall.isSensor = true
	
	for i=1 ,numOfStaticObject do
		physics.addBody(staticObject[i],"static",{density = 10, friction = 0, bounce = 1})
	end

	---------------------------------------------
	
end -------------------------------------------- end of willEnterScene


function scene:enterScene(e)
	local view = self.view
	
	--storyboard.purgeScene("mainMeny")
	--storyboard.purgeScene("restart")
	
	-------------Fade out start text-------------  
	anim = transition.to(textGroup, {
	time = 3000, 
	alpha = 0,
	onComplete = function()
			transition.cancel(anim)
			anim = nil
	end
	})
	---------------------------------------------
	
		
	---------Create levelComplete frame---------- 
	lvlComplete = levelComplete()
	lvlComplete.x = _W *0.5
	lvlComplete.y = _H *0.5
	lvlComplete.alpha = 0
	---------------------------------------------
	
	function shootBall(e)
		local view = scene.view
		local t = e.target
		local phase = e.phase
		
		if "began" == phase then
			display.getCurrentStage():setFocus(t)
			t.isFocus = true
			
			infoBtn.alpha = 0.2
			reloadBtn.alpha = 0.2
			homeBtn.alpha = 0.2
			starGroup.alpha = 0.2
			levelScore.alpha = 0.2
			lvlShotsTxt.alpha = 0.2
			
			collisionText.alpha = 0.2
			
			ball.bodyType = "dynamic"
			ball.isSensor = false
			
			----------Create Rotating aim------------
			print("create aim")
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
			if pJoints[1] ~= nil then
				pJoints[1]:removeSelf()
				pJoints[1] = nil
			end
			
			myLine = nil
			ball.isFixedRotation = true
			
			if anim ~= nil then
				transition.cancel(anim)
				anim = nil
				textGroup.alpha = 0
			end
			
			audio.play(soundEffects["aimSound"])

			
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
				myLine:setColor(244,204,34,50)
				myLine.width = 10
				view:insert(myLine)
				---------------------------------------------
				
				
			elseif "ended" == phase or "cancelled" == phase then
			
				display.getCurrentStage():setFocus(nil)
				t.isFocus = false
				
				infoBtn.alpha = 0.8
				reloadBtn.alpha = 0.8
				homeBtn.alpha = 0.8
				starGroup.alpha = 0.8
				levelScore.alpha = 0.8
				lvlShotsTxt.alpha = 0.8
				collisionText.alpha = 0.8
				
				device:removeEventListener("touch",device)
				
				--Remove aim and Line
				local stopRotation = function()
					Runtime:removeEventListener("enterFrame", startRotation)
					aim.parent:remove(aim)
					aim = nil
				end
				
				local hideAim = transition.to( aim, { alpha=0.4, xScale=1.0, yScale=1.0, time=200,onComplete=stopRotation } )
				
				if (myLine) then
					myLine.parent:remove( myLine )
					myLine = nil
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
				
				mydata.shot = mydata.shot + 1
				lvlShotsTxt.text = "Shots: " .. mydata.shot
				
				audio.stop(2)
				audio.seek(300, soundEffects["shotSound"])
				audio.play(soundEffects["shotSound"], {channel = 3, duration= 400})
				--audio.dispose(aimSound)
				--aimSound = nil
			end
		end
		return true	-- Stop further propagation of touch event
	end
	ball:addEventListener( "touch", shootBall ) -- Sets event listener to ball
	
	
	function onCollision(self, e)
		if mydata.score < 3 then
	 		if ( e.phase == "began" ) then
				mydata.collision  = mydata.collision  + 1
				collisionText.text = "Collisions: " .. mydata.collision
				star3Txt.text = "Collisions " .. mydata.collision .. "/" .. lvlCollisions
				ball.isFixedRotation = false
			end

			if e.target.type == "ball" and e.other.type == "ground" or e.other.type == "rightWall" or
			e.other.type == "leftWall" or e.other.type == "ceiling" then
				
				timer.performWithDelay(20, reset)
			
			elseif e.target.type == "ball" and e.other.type == "staticObject" or e.other.type == "dynamicObject" 
			or e.other.type == "movingObject" then

				audio.play(soundEffects["boingSound"], {duration = 400, fadein = 400})
			end
			
			for i = numOfTarget, 1, -1 do	
				if e.target.type == "ball" and e.other.type == "target" .. tostring(i)  then
					display.remove(target[i])
					target[i] = nil
					mydata.score = mydata.score + 1
					levelScore.text = "Score: " .. mydata.score
				
					audio.play(soundEffects["getTarget"], {duration = 400})
				end	
			end
			
			for i = numOfGravityTarget, 1, -1 do	
				if e.target.type == "ball" and e.other.type == "gravityTarget" .. tostring(i)  then
					display.remove(gravityTarget[i])
					gravityTarget[i] = nil
					physics.setGravity(0,9.82)
					mydata.score = mydata.score + 1
					levelScore.text = "Score: " .. mydata.score
				end	
			end
		end
	   
		if mydata.score >= lvlMonsters then
			
			lvlComplete.alpha = 1
			
			if mydata.score >= lvlMonsters and mydata.shot <= lvlShots then
				buttonNext.alpha = 1
			end
			
			infoBtn.alpha = 0
			reloadBtn.alpha = 0
			homeBtn.alpha = 0
			
			star1.alpha = 1
			physics.setGravity(0,0)
			ball.linearDamping = 5
			
			------------Possible Stars--------------
			local bool = false
			for i=1,#mydata.star do
				if mydata.star[i] == lvlStar1 then
					bool = true
				end
			end
			if bool == false then
				table.insert(mydata.star, lvlStar1)
			end
			
			star2Txt.text = "Shots " .. mydata.shot .. "/" .. lvlShots
			if mydata.shot <= lvlShots then
				local bool = false
				star2.alpha = 1
				for i=1,#mydata.star do
					if mydata.star[i] == lvlStar2 then
						bool = true
					end
				end
				if bool == false then
					table.insert(mydata.star, lvlStar2)
				end
			end
			
			if mydata.collision <= lvlCollisions then
				local bool = false
				star3.alpha = 1
				for i=1,#mydata.star do
					if mydata.star[i] == lvlStar3 then
						bool = true
					end
				end
				if bool == false then
					table.insert(mydata.star, lvlStar3)
				end
			end
			---------------------------------------
			
			if mydata.lvlUnlocked <= mydata.lvl then
				mydata.lvlUnlocked = lvlNext
			end	
			starTxt.text = #mydata.star .. "x"
		end
	end
	ball.collision = onCollision
	ball:addEventListener("collision", ball)
	
	
	--[[function onHit(self, e)

		for i = numOfMovingObject, 1, -1 do	
			if e.target.type == "ground" and e.other.type == "movingObject" .. tostring(i) then
				print("tjalala")
			end	
		end
	end	
	ground.collision = onHit
	ground:addEventListener("collision", ground)]]
	
	
	function removeTarget(target)
		for i = #target, 1, -1 do
			if(target[i] == i) then
				table.remove(target,i)
				target[i]:removeSelf()
				break
			end
		end
	end
	
	
	function restart()
		storyboard.removeScene("restart")
		storyboard.gotoScene("restart", {time =250, effect="crossFade"})
	end
	
	function reload()
		storyboard.reloadScene()
	end
	
	
	function reset()
		if ball ~= nil then 
			ball:removeEventListener("collision", ball)
			display.remove(ball)
			ball = nil
			
			resetBall()
			ball:addEventListener( "touch", shootBall )	
			ball.collision = onCollision
			ball:addEventListener("collision", ball)
			
			display.remove(device)
			device = nil
			resetDevice()
			
			infoBtn:toFront()
			reloadBtn:toFront()
			homeBtn:toFront()
			collisionText:toFront()
			levelScore:toFront()
			lvlShotsTxt:toFront()
			starGroup:toFront()
		end
	end
	
	
	function goToShop()
		storyboard.removeScene("shop")
		storyboard.gotoScene("shop", {time =250, effect="crossFade"})
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
		if dynamicObject[i] ~= nil then
		--if dynamicObject[i]._tableListeners == nil then
			--physics.removeBody(dynamicObject[i])
		--end
			display.remove(dynamicObject[i])
			dynamicObject[i] = nil
		end
	end
	
	for i = numOfStaticObject, 1, -1 do
		physics.removeBody(staticObject[i])
	end
	
	--if mydata.reload < 1 then
		--print("tjenamosh")
		for i = numOfMovingObject, 1, -1 do
			if movingObject[i] ~= nil then
				physics.removeBody(movingObject[i])
				display.remove(movingObject[i])
				movingObject[i] = nil
			end
		end
	--end	
	
	if aim ~= nil then
		aim.parent:remove(aim)
		aim = nil
	end
	
	for i = numOfTarget, 1, -1 do
		if target[i] ~= nil then
			display.remove(target[i])
			target[i] = nil
		end
	end
	
	for i = numOfGravityTarget, 1, -1 do
		if gravityTarget[i] ~= nil then
			display.remove(gravityTarget[i])
			gravityTarget[i] = nil
		end
	end
	
	levelScore.text = string.format("Score: %1d", 0)
	collisionText.text = string.format("Collisions: %1d", 0)
	lvlShotsTxt.text = string.format("Shots: %1d", 0)
	
	-- ball gets nil if reloadbutton is pressed just before the balls leave the scene
	ball:removeEventListener("collision", ball)
	display.remove(ball)
	ball = nil
	
	display.remove(device)
	device = nil
	
	--transition.cancel(anim)
	--anim = nil
	
	if anim ~= nil then
		transition.cancel(anim)
		anim = nil
		textGroup.alpha = 1

	else
		textGroup.alpha = 1
	end
	
	if pJoints[1] ~= nil then
		pJoints[1]:removeSelf()
		pJoints[1] = nil
	end
	
	if tmr ~= nil then
		timer.cancel(tmr);
		tmr = nil;
	end
	display.remove(output)
	output = nil
	
	lvlComplete.alpha = 0
	mydata.shot = 0
	mydata.collision = 0
	mydata.score = 0
	mydata.time = 60

	physics.stop()
end ---------------------------------------------- end of exitScene

scene:addEventListener("createScene", scene);
scene:addEventListener("willEnterScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);

return scene