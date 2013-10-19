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

local function onButtonHome(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, home)
	end
	return true
end

function scene:createScene(e)
	local view = self.view
	
	--------------Background--------------
	local background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,255);
	view:insert(background);
	--------------------------------------
	
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

	
	loadText = display.newText("Levels", 0, 0, native.systemFont,24)
	loadText:setTextColor(0, 0, 0, 255)
	loadText.x = _W * 0.5
	loadText.y = _H * 0.06
	view:insert(loadText)
	
	homeBtn = display.newImageRect("images/foo.png",40,40)
	homeBtn.x = _W - 25
	homeBtn.y = 25 
	homeBtn.alpha = 0.8
	homeBtn:addEventListener("touch",onButtonHome)
	view:insert(homeBtn)
	
	starGroup = display.newGroup()
	local font = "HelveticaNeue" or native.systemFont;
	starTxt = display.newText(string.format("%1dx", #mydata.star),0,0,font,15);
	starTxt:setTextColor(0,0,0)
	starTxt.x = _W - 10
	starTxt.y = _H - 10
	
	starsPic = display.newImageRect("images/star2.png",20,20)
	starsPic.x = _W - 30
	starsPic.y = _H - 15
	
	starGroup:insert(starsPic)
	starGroup:insert(starTxt)
	starGroup.alpha = 0.8
	view:insert(starGroup)
		
end


function scene:enterScene(e)
	local view = self.view
	
	storyboard.purgeScene("level1")
	
	function home()
		--audio.stop(1)
		--audio.dispose(mydata.startMusic)
		--mydata.startMusic = nil
		storyboard.removeScene("mainMeny")
		storyboard.gotoScene("mainMeny", {time =250, effect="crossFade"})
	end
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