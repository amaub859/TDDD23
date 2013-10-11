local M = {}
return M

--function removeAllListeners(obj)
  --obj._functionListeners = nil
  --obj._tableListeners = nil
--end

--[[ set velocity to the ball on the x-axis
ball:setLinearVelocity(300,0)

-- damp the device and make it invisible
device.linearDamping = 1000
device.isVisible = false

-- add physic body to the dynamic objects
for i=1 ,numOfDynamicObject do
	physics.addBody(dynamicObject[i],"static",{density = 10, friction = 0.5, bounce = 1})

	-- Remove event listeners for the dynamic objects
	dynamicObject[i]._tableListeners = nil
end]]