from   skimage.exposure import rescale_intensity
import numpy as np
import matplotlib.pyplot as plt
import argparse
import cv2

import time
import serial
import pyimgur

def sendCol(imageCol): 
    ser.write(imageCol)
    time.sleep(0.001)
    return 

def rebuildIm ():
    outInteger = []
    i = 0
    while (i < (ROWIM)*4):
        value=ord(ser.read(1))
        outInteger.append(value)
        i=i+1
    return outInteger

def upload_image(image,path,photo_name):

    #Datos de acceso IMGUR:
    #Usuario:  AJEMProcom
    #Password: quesadilla123
    
   
    PATH = path +  photo_name
    
    CLIENT_ID = "fdecbab9c6d3bc0" #proporcionado por la pagina IMGUR
    CLIENT_SECRET= "9c7ebc0e24263b9a1f1a7cd6c11815ef734aec8a" #por ahora no se usa , la dejo guardada

    im = pyimgur.Imgur(CLIENT_ID)
    uploaded_image = im.upload_image(PATH, title="foto_post_process")

   
    return uploaded_image.link

#------------------ serial port configuration -------------------------------------------

if __name__ == "__main__":

	ser = serial.Serial(
		port='/dev/ttyUSB7',		#Configurar con el puerto a usar 
		baudrate=115200,
		parity=serial.PARITY_NONE,
		stopbits=serial.STOPBITS_ONE,
		bytesize=serial.EIGHTBITS
	)
	
	ser.isOpen()
	ser.timeout=None
	# print(ser.timeout)

	#---------------------- image reading-------------------------------------------

	path  = "preteen_japan.jpeg"
	start = 1

	# ap = argparse.ArgumentParser( description = "Convolution 2D")
	# ap.add_argument("-i", "--image", required = False, help="Path to the input image",default=path)
	# ap.add_argument("-k", "--kernel", help = "Path to the kernel")
	# args = ap.parse_args()

	#Load input image 
	gray   = cv2.imread('photo.jpg',0)
	endFlag = 0

	#Convert image to gray scale
	# gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

	#zero-padding
	gray = np.pad(gray, ((1,1),(1,1)), 'constant')

	[ROWIM,COLIM] = gray.shape
	print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))


	#----------------------------------UART---------------------------------------

	ser.flushInput()
	ser.flushOutput()

	byteHeader  = bytearray()
	byteImage   = bytearray()

	byteHeader.append(0xb0)    
	byteHeader.append(0x7b)
	byteHeader.append(0x7c)
	byteHeader.append(0x4f)

	imReconsArray  = []
	imReconsMatrix = []
	imSendArray    = []
	imSendMatrix   = []
	imDecimation   = []
	n = 0
	m = 0

	#envio de imagen escalada linealmente
	while(start):
		
		if(ser.inWaiting() > 0):
			a = ser.readline()
			print(a)
			
			if (a == (b"Send header\r\n")):
				ser.write(byteHeader)
				print("Sent header\r\n")
				
			elif (a == (b"Send Image\r\n")):
				for j in range (COLIM):
					for i in range (ROWIM):
						byteImage.append(gray[i][j]) 
					sendCol(byteImage)
					byteImage.clear() 
				print("Sent Image\r\n")

			elif (a == (b"Return data\r\n")):
				while (m < (COLIM)):
					imReconsMatrix.append(rebuildIm()) 
					m = m+1
				imReconsMatrix = (np.asarray(imReconsMatrix, 'uint8').T)

				#Decimation (Elimination of zeros)
				imDecimation = imReconsMatrix[0::4,:]
					
				#Check size
				print("Size post processing (with zeros):")
				print(imReconsMatrix.shape) 
				print("Size post processing (without zeros):")
				print(imDecimation.shape) 
				
				"""
				print("COMPARACION DE MATRICES")
				print("Returned image:")
				print(imReconsMatrix)
				print("Original image:")
				print(gray)
				"""

				#Guardar las imagenes resultantes
				filename1 = 'sentImage.jpg'
				filename2 = 'receivedImage.jpg'
				filename3 = 'decimatedImage.jpg'

				cv2.imwrite(filename1, gray)
				cv2.imwrite(filename2, imReconsMatrix)
				cv2.imwrite(filename3, imDecimation)

				PATH="/home/user/work_dda/emamani/run/"




				link=upload_image(imDecimation,PATH,filename3)
				f = open("url.txt",'r+')
				f.write(link)
				f.close()

				print("Fin INTERFAZWEBUART")







				#Finaliza el procesamiento
				start = 0
				
				print("Finished processing/r")