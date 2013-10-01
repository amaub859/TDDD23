--Set up the storyboard class
local storyboard = require("storyboard");
local scene = storyboard.newScene()

--Forward references so that we can access objects accross functions
local foo;
local anim;
local background

function scene:createScene(e)	

	local view = self.view
	
	background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,255);
	
	local font = "HelveticaNeue" or native.systemFont;
    
    --Remember: this is local to the entire scene (line 6)
    foo = display.newImageRect("images/foo.png",100,100);
	foo.x = _W * 0.5;
	foo.y = _H * 0.5;
	
	view:insert(background);
    view:insert(foo);
end

function scene:enterScene(e)
	
	anim = transition.to(foo,
	{
		time = 5000,
		xScale = 2,
		yScale = 2,
		transition = easing.inQuad,
		onComplete = function() -- define a callback function to fire when the animation is completed
			--background:addEventListener("touch", startAnim)
		end
	})
	
	function goToNextFrame(e)
		if e.phase == "began" then
		storyboard.gotoScene("mainMeny", "fade", 400)
		end
	end
	
	background:addEventListener("touch", goToNextFrame)

end


function scene:exitScene(e)
	--Stop listeners, timers, and animations (transitions)
	storyboard.purgeScene("IntroLogo")--Remove all scene1 display objects
	background:removeEventListener("touch", goToNextFrame)
end

scene:addEventListener("createScene", scene);

scene:addEventListener("enterScene", scene);

scene:addEventListener("exitScene", scene);
--There are more events you can listen for;
--See the Corona docs

return scene