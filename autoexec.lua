-- Replace 192.168.116.133 with the local IP to the device running the server as long as it's on the same network
local Socket = WebSocket.connect("ws://192.168.116.133:3621")
local Thread = coroutine.running()

-- runcode is basically just task.spawn(loadstring, param1)
-- When the ws server sends a message to us, it means we need to execute the code. There is no message sent to us from the server unless "executecode" was sent to the server
Socket.OnMessage:Connect(runcode)
Socket.OnClose:Connect(function() -- If the server crashes, we want to be able to alert the user. This also keeps the script from infinitely waiting lol
	coroutine.resume(Thread)
end)

-- The socket can get GARBAGE COLLECTED, so this only lets the end of the script execute if the server dies. It's like edging, but better!
coroutine.yield()

print("Server died!")