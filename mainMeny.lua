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

function scene:createScene(e)	

	local view = self.view
	
	local background = display.newRect(0, 0, _W, _H)
	background:setFillColor(0,0,0)
	view:insert(background)
	
	for i=1 ,numOfStars do
		animationSprite[i] = display.newSprite( myImageSheet , sheetInfo:getSequenceData() )
		animationSprite[i].x =  math.random(0, _W)
		animationSprite[i].y =  math.random(0, _H)
		animationSprite[i]:setSequence( "star" )
		timer.performWithDelay(math.random(0, 1000*i), function(e)
			animationSprite[i]:play()
		end, 60)
		view:insert(animationSprite[i])
	end
	
	if music then
		audio.seek(76000, mydata.startMusic)
		audio.play(mydata.startMusic, {channel=1, loops=-1,fadein=2000})
		audio.fade( { channel=1, time=2000, volume=1 } )
	end
	
	
	local font = "HelveticaNeue" or native.systemFont;
	local txt = display.newText("Meny",0,0,font,24);
    txt:setTextColor(0,0,0);
    txt.x = _W * 0.5;
    txt.y = _H * 0.5 - 120;
    
    -------------------------------------------------------
    --Create a button class that will create button objects
	--that are complete with functionality
	local Button = {};
	Button.new = function(params)
	
		local btn = display.newGroup();
		
		local offIMG = params and params.off or "images/grass_bottom.png";
		local onIMG = params and params.on or "images/background_sky.png";
		
		local off = display.newImageRect(offIMG, 150, 50);
		local on = display.newImageRect(onIMG, 150, 50);
		
		--Set the alpha of the on state to 0
		on.alpha = 0;
		
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

	local playButton = Button.new()
	playButton.x = _W * 0.5
	playButton.y = _H * 0.5 -70 
	
	local optionButton = Button.new()
	optionButton.x = _W * 0.5
	optionButton.y = _H * 0.5
	
	local creditButton = Button.new()
	creditButton.x = _W * 0.5
	creditButton.y = _H * 0.5 + 70
    
  
	function playButton:tap(e)
		storyboard.removeScene("nextLevel")
		storyboard.gotoScene("nextLevel", "fade", 400)
	end
	
	playButton:addEventListener("tap",playButton);
	
	function optionButton:tap(e)
		storyboard.removeScene("shop")
		storyboard.gotoScene("shop", "fade", 400)
	end
	
	optionButton:addEventListener("tap",optionButton);
	
	function creditButton:tap(e)
		storyboard.gotoScene("credit", "fade", 400)
	end
	
	creditButton:addEventListener("tap",creditButton);
	
    view:insert(txt);
    view:insert(playButton);
    view:insert(optionButton);
    view:insert(creditButton);
end

function scene:enterScene(e)
	
	
end

function scene:exitScene(e)
	--Stop listeners, timers, and animations (transitions)
	
	storyboard.purgeScene("mainMeny") --Remove all scene1 display objects
	for i = numOfStars, 1, -1 do
		animationSprite[i]:pause()
		--display.remove(animationSprite[i])
		--animationSprite[i] = nil
	end
	
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