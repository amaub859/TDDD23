--Set up the storyboard class
local storyboard = require("storyboard");
local scene = storyboard.newScene()

--Forward references so that we can access objects accross functions
local bar;
local spinIt;

function scene:createScene(e)	

	local view = self.view
	
	local background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,0);
	
	local font = "HelveticaNeue" or native.systemFont;
	local txt = display.newText("Scene 4",0,0,font,24);
    txt:setTextColor(0,0,0);
    txt.x = _W * 0.5;
    txt.y = _H * 0.5;
    
    --Remember: this is local to the entire scene (line 6)
    bar = display.newImageRect("images/bar.png",100,100);
	bar.x = _W * 0.5;
	bar.y = _H - 80;
	
	function txt:tap(e)
		storyboard.gotoScene("mainMeny",{
			effect = "slideDown", -- transition effect to implement
			time = 250 -- duration of the transition effect in milliseconds
		});
	end
	
	txt:addEventListener("tap",txt);
	
	view:insert(background);
    view:insert(txt);
    view:insert(bar);
end

function scene:enterScene(e)
	function spinIt(e)
		bar.rotation = (bar.rotation - 10) % 360;
	end
	Runtime:addEventListener("enterFrame",spinIt);
end

function scene:exitScene(e)
	--Stop listeners, timers, and animations (transitions)
	Runtime:removeEventListener("enterFrame",spinIt);
	storyboard.purgeScene("options");--Remove all scene1 display objects
end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);
--There are more events you can listen for;
--See the Corona docs

return scene