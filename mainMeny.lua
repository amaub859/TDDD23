--Set up the storyboard class
local storyboard = require("storyboard");
local scene = storyboard.newScene()

--Use audio.loadSound for very short sounds and fx
local startMusic = audio.loadStream("music/SummertimeSadness.mp3");

--Forward references so that we can access objects accross functions
local bar;
local spinIt;

function scene:createScene(e)	

	local view = self.view
	
	local background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,255);
	
	audio.seek(76000, startMusic)
	audio.play(startMusic, {channel=1, loops=-1,fadein=1000})
	
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
		storyboard.gotoScene("nextLevel", "fade", 400)
	end
	
	playButton:addEventListener("tap",playButton);
	
	function optionButton:tap(e)
		storyboard.gotoScene("options", "fade", 400)
	end
	
	optionButton:addEventListener("tap",optionButton);
	
	function creditButton:tap(e)
		storyboard.gotoScene("credit", "fade", 400)
	end
	
	creditButton:addEventListener("tap",creditButton);
	
	view:insert(background);
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
	
	--playButton:removeEventListener("tap",playButton)
	--optionButton:removeEventListener("tap",optionButton)
	--creditButton:removeEventListener("tap",creditButton)
	--audio.pause(1)
	
	audio.stop(1)
	audio.dispose(startMusic)
	startMusic = nil
	print("exitScene")
end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);
--There are more events you can listen for;
--See the Corona docs

return scene