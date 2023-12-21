-- Replace 192.168.4.20 with the local IP to the device running the server as long as it's on the same network
local Socket = WebSocket.connect("ws://192.168.4.20:3621")
local Thread = coroutine.running()

-- When the ws server sends a message to us, it means we need to execute the code. There is no message sent to us from the server unless "executecode" was sent to the server
Socket.OnMessage:Connect(function(Code)
	local Func, Error = loadstring(Code)

	if not Func then 
		warn(Error)
	else
		task.spawn(Func)
	end
end)
Socket.OnClose:Connect(function() -- If the server crashes, we want to be able to alert the user. This also keeps the script from infinitely waiting lol
	coroutine.resume(Thread)
end)

-- The socket can get GARBAGE COLLECTED, so this only lets the end of the script execute if the server dies.
coroutine.yield()

print("Server died!")
