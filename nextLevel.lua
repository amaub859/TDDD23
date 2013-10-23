--Set up the storyboard class
local storyboard = require("storyboard")
local scene = storyboard.newScene()

local mydata = require("mydata")

local sheetInfo = require("Animation")
local myImageSheet = graphics.newImageSheet( "images/Animation.png", sheetInfo:getSheet() )

local txtTop
local numOfLevels = 12;
local numOfStars = 80
local animationSprite = {}
local levelButton = {}
local timerId = {}
local count = 1 

local myFont = (platform ~= "Android") and "Manteka" or system.nativeFont

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

function play()
	animationSprite[count]:play()
	count = count + 1
end


function scene:createScene(e)
	local view = self.view
	
	--------------Background--------------
	local background = display.newImageRect("images/background/bg.png",570,360)
	background.x = _W * 0.5;
	background.y = _H * 0.5;
	view:insert(background);
	--------------------------------------

	for i=1 ,numOfStars do
		
			animationSprite[i] = display.newSprite( myImageSheet , sheetInfo:getSequenceData() )
			animationSprite[i].x =  math.random(0, _W)
			animationSprite[i].y =  math.random(0, _H)
			animationSprite[i]:setSequence( "star" )
			timerId[i] = timer.performWithDelay(math.random(0, 1000*i), play, 1)
			view:insert(animationSprite[i])
	end

	local background2 = display.newImageRect("images/background/bg2levels.png",570,360)
	background2.x = _W * 0.5;
	background2.y = _H * 0.5;
	view:insert(background2);
	
	local col = 1
	local row = 1
	
	for i=1 ,numOfLevels do
		levelButton[i] = display.newGroup()
		local opened = display.newImageRect("images/levelButton/levelBtn" .. i .. ".png", 60, 60)
		local locked = display.newImageRect("images/levelButton/buttonLocked.png", 60, 60)
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
						mydata.lvl = e.target.tag
						storyboard.removeScene("levels")
						storyboard.gotoScene("levels", {time =250, effect="crossFade"})
						
											
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
		levelButton[i].y = row *_H/5 + 40
		col = col + 1
		
		view:insert(levelButton[i])
	end
	
	levelsTxt = display.newImageRect("images/levelsTxt.png",135,40);
	levelsTxt.x = _W * 0.5;
	levelsTxt.y = _H * 0.5 - 125
    view:insert(levelsTxt);
	
	
	homeBtn = display.newImageRect("images/homeBtn.png",40,40)
	homeBtn.x = _W - 25
	homeBtn.y = 25 
	homeBtn.alpha = 1
	homeBtn:addEventListener("touch",onButtonHome)
	view:insert(homeBtn)
	
	starGroup = display.newGroup()
	starTxt = display.newText(string.format("%1dx", #mydata.star),0,0,myFont,10)
	starTxt:setTextColor(244,204,34)
	starTxt.x = _W - 15
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
		storyboard.removeScene("mainMeny")
		storyboard.gotoScene("mainMeny", {time =250, effect="crossFade"})
	end
	--txtTop.alpha = 1.0
	--transition.to(txtTop, {time=500, alpha=0.0, onComplete=restartLevel})
end

function scene:exitScene(e)
	local view = self.view
	
	for i=1 ,#timerId do
		timer.cancel(timerId[i])
	end
	
	for i = numOfStars, 1, -1 do 
		animationSprite[i]:pause()
		display.remove(animationSprite[i])
		animationSprite[i] = nil
	end
	
	for i= numOfLevels, 1, -1 do 
		display.remove(levelButton[i])
		levelButton[i] = nil
	end
	
	display.remove(starGroup)
	starGroup = nil
	
	display.remove(homeBtn)
	homeBtn = nil
	
	display.remove(background)
	background = nil
	
	display.remove(background2)
	background2 = nil

end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);


return scene