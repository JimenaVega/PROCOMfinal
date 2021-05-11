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
#import interfazWebUART
import Final_InterfazWebRTC_Python
from aiohttp import web
from base64 import b64encode
import requests
import pyimgur
from av import VideoFrame
from aiortc import MediaStreamTrack, RTCPeerConnection, RTCSessionDescription
from aiortc.contrib.media import MediaBlackhole, MediaPlayer, MediaRecorder
from rtcbot import RTCConnection, getRTCBotJS, CVCamera, CVDisplay

import threading


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

condicion=1

f = open("url.txt",'r+')
f.truncate(0)
f.close()
class VideoTransformTrack(MediaStreamTrack):
    """
    A video stream track that transforms frames from an another track.
    """

    kind = "video"

    row=0
    col=0

    def __init__(self, track, rows, cols, kernel):
        super().__init__()  # don't forget this!
        self.track = track
        self.rows = rows
        self.cols = cols
        self.kernel = kernel
        
        global row
        row=rows
        global col
        col=cols
        imagen_gris = np.ndarray(shape=(row,col),dtype='uint8') #se hace una variable global para accederla luego
        pic = np.ndarray(shape=(row,col),dtype='uint8')
        self.edgeMatrix = np.array((
	    [-1, -1, -1],
	    [-1,  8, -1],
	    [-1, -1, -1]), dtype="int")

    

  
    async def recv(self):


        global condicion
        if(condicion)==0:
            print("la condicion fue cambiada")
            hilo = threading.Thread(target=funcion).start()
            hilo2= threading.Thread(target=funcion2).start()
            print("el hilo fue ejecutado")

            
            condicion=1

        frame = await self.track.recv()
        

        img  = frame.to_ndarray(format="bgr24")
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        

        global imagen_gris
        
        imagen_gris=gray #copia a gray

        
        
        # if(self.kernel == 1):   
        #     gauss = cv2.GaussianBlur(gray, (5,5), 0)
        #     canny = cv2.Canny(gauss, 50, 150)
        #     (countours,_) = cv2.findContours(canny.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        #     cv2.drawContours(img,countours,-1,(255,0,0), 1)
        # elif(self.kernel == 2):
        #     _, thrash   = cv2.threshold(gray,240,255,cv2.THRESH_BINARY)
        #     countours,_ = cv2.findContours(thrash,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)
        #     for countour in countours:
        #         approx = cv2.approxPolyDP(countour,0.01*cv2.arcLength(countour,True),True)
        #         cv2.drawContours(img,[approx],0,(0,0,0),5)
        #         x = approx.ravel()[0]
        #         y = approx.ravel()[1]
        #         if   len(approx)==3:
        #             cv2.putText(img,"Triangle", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
        #         elif len(approx)==4:
        #             x,y,w,h = cv2.boundingRect(approx)
        #             aspectRatio = float(w)/h
        #             if aspectRatio >= 0.95 and aspectRatio <= 1.05:
        #                 cv2.putText(img,"Square", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
        #             else:
        #                 cv2.putText(img,"Rectangule", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
        #         elif len(approx)==5:
        #             cv2.putText(img,"Pentagon", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
        #         elif len(approx)==10:
        #             cv2.putText(img,"Rectangule", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))
        #         else:
        #             cv2.putText(img,"Circle", (x,y),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,0,0))

        new_frame = VideoFrame.from_ndarray(img, format="bgr24")
        new_frame.pts = frame.pts
        new_frame.time_base = frame.time_base

        return new_frame


#carga el html
async def index(request):
    content = open(os.path.join(ROOT, "index2.html"), "r").read()
    return web.Response(content_type="text/html", text=content)


# Carga el archivo de javascript RTCBOT
async def rtcbotjs(request):
    return web.Response(content_type="application/javascript", text=getRTCBotJS())



#Carga el javascript client
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
    # close peer connections (ambas)
    await conn.close()
    coros = [pc.close() for pc in pcs]
    await asyncio.gather(*coros)
    pcs.clear()






 #Cuando se presione el boton de enviar foto, se entra al condicional
@conn.subscribe
async def onMessage(msg):  # Called when each message is sent

    global pic
   

    if(msg=='take_photo'):
        
        global imagen_gris # es la imagen del frame actual, NO es la imagen de Take_Photo, eso lo tengo que corregir
        
        pic = imagen_gris #congela el frame del stream, para que se iguale con la foto que se muestra
        px_deseados=40

        
        width_start= int((pic.shape[0]/2)-(px_deseados/2))
        width_end=int((pic.shape[0]/2)+(px_deseados/2))
        heigh_start=int((pic.shape[1]/2)-(px_deseados/2))
        heigh_end=int((pic.shape[1]/2)+(px_deseados/2))
        print (pic.shape)
       
        print(width_start)
        print(width_end)
        print(heigh_start)
        print(heigh_end)
        crop_img = pic[width_start:width_end , heigh_start:heigh_end]
        # print(crop_img)
        # print(crop_img.shape)
        # print (type(crop_img))

       
        cv2.imwrite("photo.jpg",crop_img) #es otra opcion para hacerlo pero requiere guardar la foto
        
        print("LISTO")
        
       
        # cv2.imshow("asd",imAfterUART)
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()
        
        
        # # os.system('python interfazWebUART.py --image photo.jpg')
        global condicion
        condicion=0
        
        
    # if(msg=='send_photo'):
        


def funcion():
    time.sleep(0.1)
    os.system("python Final_InterfazWebRTC_Python.py")
    # os.system("python interfazWebUART.py")
    
    
def funcion2():

    while(1):

        if os.stat("url.txt").st_size == 0:
            pass
        else:
            print('File is not empty')
            f=open("url.txt","r+")
            link=f.read()
            conn.put_nowait({"im_url": link})
            f.truncate(0)
            f.close()
            break


    
    

       
    
async def upload_image(image,path,photo_name):

    #Datos de acceso IMGUR:
    #Usuario:  AJEMProcom
    #Password: quesadilla123
    
   
    PATH = path +  photo_name
    
    CLIENT_ID = "fdecbab9c6d3bc0" #proporcionado por la pagina IMGUR
    CLIENT_SECRET= "9c7ebc0e24263b9a1f1a7cd6c11815ef734aec8a" #por ahora no se usa , la dejo guardada

    im = pyimgur.Imgur(CLIENT_ID)
    uploaded_image = im.upload_image(PATH, title="foto_post_process")

   
    return uploaded_image.link
    

def kill_process(): #si el puerto esta ocupado, lo libera para ejecutar el server
    PID = os.popen("netstat -ano|findstr 8086").read() #busca el process ID para ese puerto
    PID=PID[::-1]
    trim=[]
    for i, chrt in enumerate(PID):#recorre la respuesta desde el final y guarda el process ID
        if (' ' == chrt):
            break
        trim.append(chrt)

    try: 
        trim.remove('\n')
        PID=''.join(trim)[::-1]
        
        os.system("taskkill /f /PID {}".format(PID)) #libera el puerto para iniciar el server

    except: #en caso que el puerto no este siendo usado, no hace nada
        pass   



# es la conexion para el envio de mensajes
async def connect(request):
    clientOffer = await request.json()
    serverResponse = await conn.getLocalDescription(clientOffer)
    return web.json_response(serverResponse)




if __name__ == "__main__":
    
  
    parser = argparse.ArgumentParser(
        description="WebRTC audio / video / data-channels demo"
    )
    parser.add_argument("--cert-file", help="SSL certificate file (for HTTPS)",default='example.crt')
    parser.add_argument("--key-file", help="SSL key file (for HTTPS)",default='example.key')
    parser.add_argument(
        "--port", type=int, default=8086, help="Port for HTTP server (default: 8086)"
    )
    parser.add_argument("--verbose", "-v", action="count")
    parser.add_argument("--write-audio", help="Write received audio to a file")

    args = parser.parse_args()
    # python server.py --cert-file example.cert --key-file example.key
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)

    if args.cert_file:
        ssl_context = ssl.SSLContext()
        ssl_context.load_cert_chain(args.cert_file, args.key_file)
    else:
        ssl_context = None


    # kill_process()
    app = web.Application()
    app.on_shutdown.append(on_shutdown)
    app.router.add_get("/", index)
    app.router.add_get("/client.js", javascript) #se agregan las funciones  a usar
    app.router.add_post("/offer", offer)
    app.router.add_get("/rtcbot.js",rtcbotjs)
    app.router.add_post("/connect",connect)
    web.run_app(app, access_log=None, port=args.port, ssl_context=ssl_context)
    