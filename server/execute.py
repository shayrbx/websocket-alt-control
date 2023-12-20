from websockets.sync.client import connect

# Because we're executing the script on the same device running the server, we can use localhost
with connect("ws://127.0.0.1:3621") as socket:
    socket.send("execute_script")
    print("Executed script")
    socket.close()