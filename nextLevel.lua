--Set up the storyboard class
local storyboard = require("storyboard")
local scene = storyboard.newScene()

local mydata = require("mydata")

local loadText
local numOfLevels = 16;
local levelButton = {}

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
	local levelScore = display.newText(string.format("Score: %1d", mydata.score),0,0,font,24);
    levelScore:setTextColor(0,0,0);
    levelScore.x = 50;
    levelScore.y = 40;
    view:insert(levelScore);
    --------------------------------------
    
    ---------------lvlText----------------
    local lvlText = display.newText(string.format("Level: %1d", mydata.lvl),0,0,font,24)
    lvlText:setTextColor(0,0,0)
    lvlText.x = 50
    lvlText.y = 20
    view:insert(lvlText)
    --------------------------------------
    
	--[[local Button = {};
	Button.new = function(params)
		
		local btn = display.newGroup();
		
		local offIMG = params and params.off or "images/background_sky.png"
		local onIMG = params and params.on or "images/grass_bottom.png"
		local locked = params and params.lock or "images/foo.png"
		
		local off = display.newImageRect(offIMG, 50, 50);
		local on = display.newImageRect(onIMG, 50, 50);
		local lock = display.newImageRect(locked, 50, 50) 
		
		--Set the alpha of the on state to 0
		on.alpha = 0;
		
		--Insert the objects into the group
		--insert on second so that it appears on top
		--of off
		btn:insert(off);
		btn:insert(on);
		btn:insert(lock)
		
		btn.x = params and params.x or 0;
		btn.y = params and params.y or 0;
		
		function btn:touch(e)
			if(e.phase == "began") then
				on.alpha = 1;--make the on-state visible
				display.getCurrentStage():setFocus(self);
				self.hasFocus = true;
			elseif(self.hasFocus) then
				if(e.phase == "ended") then
					on.alpha = 0;--make the on-state invisible
					display.getCurrentStage():setFocus(nil);
					self.hasFocus = false;
				end
			end
		end
		
		btn:addEventListener("touch",btn);
		
		return btn;
	end --end Button class declaration ]]
	
	local col = 1
	local row = 1
	
	for i=1 ,numOfLevels do
		levelButton[i] = display.newGroup()
		local opened = display.newImageRect("images/foo.png", 50, 50)
		local locked = display.newImageRect("images/bar.png", 50, 50)
		levelButton[i]:insert(opened)
		levelButton[i]:insert(locked)
		levelButton[i].tag = i
		
		if i <= mydata.lvlUnlocked then	
			locked.alpha = 0
			
			--local btn = levelButton[i]
			
			function touchIt(e)
				if(e.phase == "began") then
					--levelButton[e.target.tag].alpha = 0
					--locked.alpha = 0
					--print(e.target.tag)
					--print(mydata.lvlUnlocked)
					--display.getCurrentStage():setFocus(self);
					--self.hasFocus = true;

				elseif(e.phase == "ended" or e.phase == "cancelled") then
						mydata.score = 0
						mydata.collision = 0
						mydata.reload = 0
						storyboard.removeScene("level" .. mydata.lvl)
						storyboard.gotoScene("level" .. e.target.tag)
											
						--display.getCurrentStage():setFocus(nil);
						--self.hasFocus = false;
				end
			end
			
			levelButton[i]:addEventListener("touch",touchIt);
		end
		
		if col == 5 then
			col = 1
			row = row + 1		
		end
		
		levelButton[i].x = col *_W/5
		levelButton[i].y = row *_H/5
		col = col + 1
		
		view:insert(levelButton[i])
	end

	
	loadText = display.newText("Congratulations!", 0, 0, native.systemFont,24)
	loadText:setTextColor(0, 0, 0, 255)
	loadText.x = _W * 0.5
	loadText.y = _H * 0.5
	
	view:insert(loadText)
	
	
	
	function reload(e)
		local prev = mydata.lvl - 1
			if e.phase == "began" then
				--storyboard.removeScene("level" .. prev)
				--storyboard.gotoScene("level" .. mydata.lvl)
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
	--physics.stop()
end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);


return scene