--Set up the storyboard class
local storyboard = require("storyboard")
local scene = storyboard.newScene()

local mydata = require("mydata")

local loadText

local function createObject()
	local view = scene.view
	local object = display.newImageRect("images/platform.png", 100, 25);
	
	return object
end

function scene:createScene(e)
	local view = self.view
	
	--------------Background--------------
	local background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,255);
	view:insert(background);
	--------------------------------------
	
	--------------scoreText---------------
	local font = "HelveticaNeue" or native.systemFont;
	local txt = display.newText("Score:",0,0,font,24);
    txt:setTextColor(0,0,0);
    txt.x = 50;
    txt.y = 40;
    view:insert(txt);
    --------------------------------------
    
    ---------------lvlText----------------
    local lvlText = display.newText(string.format("Levelhej: %1d", mydata.lvl),0,0,font,24)
    lvlText:setTextColor(0,0,0)
    lvlText.x = 50
    lvlText.y = 20
    view:insert(lvlText)
    --------------------------------------
    
    --------------device------------------   
    device = display.newImageRect("images/foo.png",50,50);
	device.x = 20;
	device.y = _H *0.5;
	
	view:insert(device)
	--------------------------------------
	
	----------------Ball------------------  
	ball = display.newImageRect("images/foo.png",25,25)
	ball.x = _W * 0.5 - 190
	ball.y = _H * 0.5
	ball.type = "ball"
	
	view:insert(ball)
	--------------------------------------

	----------------Objects----------------  
	local playObject = createObject()
	playObject.x = _W * 0.5
	playObject.y = _H * 0.5 
	view:insert(playObject)

	local playObject2 = createObject()
	playObject2.x = _W * 0.5 + 100
	playObject2.y = _H * 0.5 
    view:insert(playObject2)
	--------------------------------------
	
	loadText = display.newText("Congratulations!", 0, 0, native.systemFont,24)
	loadText:setTextColor(0, 0, 0, 255)
	loadText.x = _W * 0.5
	loadText.y = _H * 0.5
	
	view:insert(loadText)
	
	
	
	function reload(e)
		local prev = mydata.lvl - 1
			if e.phase == "began" then
				storyboard.removeScene("level" .. prev)
				storyboard.gotoScene("level" .. mydata.lvl)
			end
	end
		background:addEventListener("touch", reload)
	
end

function scene:enterScene(e)
	local view = self.view
	
	storyboard.purgeScene("level1")
	--loadText.alpha = 1.0
	--transition.to(loadText, {time=500, alpha=0.0, onComplete=restartLevel})
end

function scene:exitScene(e)
	local view = self.view
	physics.stop()
end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);


return scene