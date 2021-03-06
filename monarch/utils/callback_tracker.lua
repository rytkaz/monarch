local M = {}


function M.create()
	local instance = {}

	local callback = nil
	local callback_count = 0

	local function invoke_if_done()
		if callback_count == 0 and callback then
			local ok, err = pcall(callback)
			if not ok then print(err) end
		end
	end

	--- Create a callback function and track when it is done
	-- @return Callback function
	function instance.track()
		callback_count = callback_count + 1
		return function()
			callback_count = callback_count - 1
			invoke_if_done()
		end
	end

	--- Call a function when all callbacks have been triggered
	-- @param cb Function to call when all 
	function instance.when_done(cb)
		callback = cb
		invoke_if_done()
	end

	return instance
end


return setmetatable(M, {
	__call = function(_, ...)
		return M.create(...)
	end
})