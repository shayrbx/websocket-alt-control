"""
This is all skidded from stackoverflow and documentation lol
The only lines I actually added were 21-25
"""

import asyncio
import websockets

CLIENTS = set()

async def broadcast(message):
    for websocket in CLIENTS.copy():
        try:
            await websocket.send(message)
        except websockets.ConnectionClosed:
            pass

async def handler(websocket):
    CLIENTS.add(websocket)
    try:
        async for message in websocket:
            if message == "execute_script":
                print("Sending the script to every client!")
                
                script = open("script.lua", "r")
                await broadcast(message=script.read())
                script.close()
        await websocket.wait_closed()
    finally:
        CLIENTS.remove(websocket)

async def main():
    print("Execution server is running!")

    async with websockets.serve(handler, "", 3621):
        await asyncio.Future()  # run forever

asyncio.run(main())
