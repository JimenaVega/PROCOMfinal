import argparse
import asyncio
import subprocess
import json
import logging
import os
import ssl
import uuid
import numpy as np
import os
import cv2
# import sysv_ipc
import time

from aiohttp import web



from av import VideoFrame



from aiortc import MediaStreamTrack, RTCPeerConnection, RTCSessionDescription
from aiortc.contrib.media import MediaBlackhole, MediaPlayer, MediaRecorder

from rtcbot import RTCConnection, getRTCBotJS

conn = RTCConnection()

routes = web.RouteTableDef()

# For this example, we use just one global connection

ROOT = os.path.dirname(__file__)

logger = logging.getLogger("pc")
pcs = set()

flag='0'

imagen  = cv2.imread('foto1.jpg')

conn = RTCConnection()
routes = web.RouteTableDef()

class VideoTransformTrack(MediaStreamTrack):
    """
    A video stream track that transforms frames from an another track.
    """

    kind = "video"

    def __init__(self, track, rows, cols, kernel):
        super().__init__()  # don't forget this!
        self.track = track
        self.rows = rows
        self.cols = cols
        self.kernel = kernel
        self.edgeMatrix = np.array((
	    [-1, -1, -1],
	    [-1,  8, -1],
	    [-1, -1, -1]), dtype="int")


    
    async def recv(self):
        frame = await self.track.recv()
        flag=0
        img  = frame.to_ndarray(format="bgr24")
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        if(flag=='0'):
            imagen=gray
            cv2.imshow('imagen',imagen)
            cv2.waitKey(0)
            cv2.destroyAllWindows()
            flag=1
        
        
        if(self.kernel == 1):   
            gauss = cv2.GaussianBlur(gray, (5,5), 0)
            canny = cv2.Canny(gauss, 50, 150)
            (countours,_) = cv2.findContours(canny.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
            cv2.drawContours(img,countours,-1,(255,0,0), 1)
        elif(self.kernel == 2):
            _, thrash   = cv2.threshold(gray,240,255,cv2.THRESH_BINARY)
            countours,_ = cv2.findContours(thrash,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)
            for countour in countours:
                approx = cv2.approxPolyDP(countour,0.01*cv2.arcLength(countour,True),True)
                cv2.drawContours(img,[approx],0,(0,0,0),5)
                x = approx.ravel()[0]
                y = approx.ravel()[1]
                if   len(approx)==3:
                    cv2.putText(img,"Triangle", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
                elif len(approx)==4:
                    x,y,w,h = cv2.boundingRect(approx)
                    aspectRatio = float(w)/h
                    if aspectRatio >= 0.95 and aspectRatio <= 1.05:
                        cv2.putText(img,"Square", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
                    else:
                        cv2.putText(img,"Rectangule", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
                elif len(approx)==5:
                    cv2.putText(img,"Pentagon", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
                elif len(approx)==10:
                    cv2.putText(img,"Rectangule", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
                else:
                    cv2.putText(img,"Circle", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))

        new_frame = VideoFrame.from_ndarray(img, format="bgr24")
        new_frame.pts = frame.pts
        new_frame.time_base = frame.time_base

        return new_frame


async def index(request):
    content = open(os.path.join(ROOT, "index2.html"), "r").read()
    return web.Response(content_type="text/html", text=content)


# Serve the RTCBot javascript library at /rtcbot.js

async def rtcbotjs(request):
    return web.Response(content_type="application/javascript", text=getRTCBotJS())




async def javascript(request):
    content = open(os.path.join(ROOT, "client.js"), "r").read()
    return web.Response(content_type="application/javascript", text=content)


async def offer(request):
    params = await request.json()
    offer = RTCSessionDescription(sdp=params["sdp"], type=params["type"])

    pc = RTCPeerConnection()
    
    pc_id = "PeerConnection(%s)" % uuid.uuid4()
    pcs.add(pc)

    def log_info(msg, *args):
        logger.info(pc_id + " " + msg, *args)

    log_info("Created for %s", request.remote)


    @pc.on("track")
    def on_track(track):
        log_info("Track %s received", track.kind)
        
        if track.kind == "video":
            print(params["kernel_ref"])
            local_video = VideoTransformTrack(
                track, rows=int(params["width_height"].split('x')[1]) , cols=int(params["width_height"].split('x')[0]), kernel=int(params["kernel_ref"])
            )

            pc.addTrack(local_video)

    # handle offer
    await pc.setRemoteDescription(offer)

    # send answer
    answer = await pc.createAnswer()
    await pc.setLocalDescription(answer)

    return web.Response(
        content_type="application/json",
        text=json.dumps(
            {"sdp": pc.localDescription.sdp, "type": pc.localDescription.type}
        ),
    )
    


async def on_shutdown(app):
    # close peer connections
    await conn.close()
    coros = [pc.close() for pc in pcs]
    await asyncio.gather(*coros)
    pcs.clear()




@conn.subscribe
def onMessage(msg):  # Called when each message is sent
    print("Got message:", msg)




# This sets up the connection

async def connect(request):
    clientOffer = await request.json()
    serverResponse = await conn.getLocalDescription(clientOffer)
    return web.json_response(serverResponse)



if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="WebRTC audio / video / data-channels demo"
    )
    parser.add_argument("--cert-file", help="SSL certificate file (for HTTPS)")
    parser.add_argument("--key-file", help="SSL key file (for HTTPS)")
    parser.add_argument(
        "--port", type=int, default=8080, help="Port for HTTP server (default: 8080)"
    )
    parser.add_argument("--verbose", "-v", action="count")
    parser.add_argument("--write-audio", help="Write received audio to a file")

    args = parser.parse_args()

    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)

    if args.cert_file:
        ssl_context = ssl.SSLContext()
        ssl_context.load_cert_chain(args.cert_file, args.key_file)
    else:
        ssl_context = None

    app = web.Application()
    app.on_shutdown.append(on_shutdown)
    app.router.add_get("/", index)
    app.router.add_get("/client.js", javascript)
    app.router.add_post("/offer", offer)
    app.router.add_get("/rtcbot.js",rtcbotjs)
    app.router.add_post("/connect",connect)
    web.run_app(app, access_log=None, port=args.port, ssl_context=ssl_context)
    



