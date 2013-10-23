--Set up the storyboard class
local storyboard = require("storyboard");
local scene = storyboard.newScene()

local mydata = require("mydata")
local music = false

local sheetInfo = require("Animation")
local myImageSheet = graphics.newImageSheet( "images/Animation.png", sheetInfo:getSheet() )

--Use audio.loadSound for very short sounds and fx
if mydata.startMusic == nil then
	mydata.startMusic = audio.loadStream("sound/SummertimeSadness.mp3");
	music = true
end

--Forward references so that we can access objects accross functions
local bar
local spinIt
local numOfStars = 40
local animationSprite = {}
local count = 1 
local count2 = 1
local timerId = {}

local myFont = (platform ~= "Android") and "Manteka" or system.nativeFont

function play()
	animationSprite[count2]:play()
	count2 = count2 + 1
end

function scene:createScene(e)	

	local view = self.view
	
	local background = display.newImageRect("images/background/bg.png",570,360)
	background.x = _W * 0.5;
	background.y = _H * 0.5;
	view:insert(background);
	
	for i=1 ,numOfStars do
		
			animationSprite[i] = display.newSprite( myImageSheet , sheetInfo:getSequenceData() )
			animationSprite[i].x =  math.random(0, _W)
			animationSprite[i].y =  math.random(0, _H)
			animationSprite[i]:setSequence( "star" )
			timerId[i] = timer.performWithDelay(math.random(0, 1000*i), play, 1)
			view:insert(animationSprite[i])
	end
	
	local background2 = display.newImageRect("images/background/bg2.png",570,360)
	background2.x = _W * 0.5;
	background2.y = _H * 0.5;
	view:insert(background2);
	
	if music then
		audio.seek(76000, mydata.startMusic)
		audio.play(mydata.startMusic, {channel=1, loops=-1,fadein=2000})
		audio.fade( { channel=1, time=2000, volume=1 } )
	end
	
	logo = display.newImageRect("images/logo2.png",200,40);
	logo.x = _W * 0.5;
	logo.y = _H * 0.5 -125 
    view:insert(logo);
    
    -------------------------------------------------------
    --Create a button class that will create button objects
	--that are complete with functionality
	local Button = {};
	Button.new = function(params)
	
		local btn = display.newGroup()

		if count == 1 then		
			 offIMG = params and params.off or "images/buttons/startButton.png"
			 onIMG = params and params.on or "images/buttons/startButtonIn.png"
		elseif count == 2 then
			 offIMG = params and params.off or "images/buttons/settingsButton.png"
			 onIMG = params and params.on or "images/buttons/settingsButtonIn.png"
		elseif count == 3 then
			 offIMG = params and params.off or "images/buttons/shopButton.png"
			 onIMG = params and params.on or "images/buttons/shopButtonIn.png"
		end

		
		local off = display.newImageRect(offIMG, 150, 50);
		local on = display.newImageRect(onIMG, 150, 50);
		
		--Set the alpha of the on state to 0
		on.alpha = 0
		
		--Insert the objects into the group
		--insert on second so that it appears on top
		--of off
		btn:insert(off);
		btn:insert(on);
		
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
	end 
	--end Button class declaration
	-------------------------------------------------------

	count = 1
	local playButton = Button.new()
	playButton.x = _W * 0.5
	playButton.y = _H * 0.5 -60
	
	count = 2
	local optionButton = Button.new()
	optionButton.x = _W * 0.5
	optionButton.y = _H * 0.5
	
	count = 3
	local shopButton = Button.new()
	shopButton.x = _W * 0.5
	shopButton.y = _H * 0.5 + 60
    
  
	function playButton:tap(e)
		storyboard.removeScene("nextLevel")
		storyboard.gotoScene("nextLevel", "fade", 400)
	end
	
	playButton:addEventListener("tap",playButton);
	
	function optionButton:tap(e)

	end
	
	optionButton:addEventListener("tap",optionButton);
	
	function shopButton:tap(e)
		storyboard.removeScene("shop")
		storyboard.gotoScene("shop", "fade", 400)
	end
	
	shopButton:addEventListener("tap",shopButton);
	
    view:insert(playButton);
    view:insert(optionButton);
    view:insert(shopButton);
end

function scene:enterScene(e)
	
	
end

function scene:exitScene(e)
	--Stop listeners, timers, and animations (transitions)
	
	storyboard.purgeScene("mainMeny")
	--[[
	for i=1 ,#timerId do
		timer.cancel(timerId[i])
	end
	
	for i = numOfStars, 1, -1 do 
		animationSprite[i]:pause()
		--display.remove(animationSprite[i])
		--animationSprite[i] = nil
	end
	
	display.remove(background)
	background = nil
	
	display.remove(background2)
	background2 = nil
	
	display.remove(playButton)
	playButton = nil
	
	display.remove(optionButton)
	optionButton = nil
	
	display.remove(shopButton)
	shopButton = nil]]
	
	
	--playButton:removeEventListener("tap",playButton)
	--optionButton:removeEventListener("tap",optionButton)
	--creditButton:removeEventListener("tap",creditButton)
	--audio.pause(1)
	--print("exitScene")
end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);
--There are more events you can listen for;
--See the Corona docs

return scene