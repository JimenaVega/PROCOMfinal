import cv2
import interfazWebUART
import threading
import concurrent.futures
import time
import queue
import multiprocessing
import os

os.system("python interfazWebUART.py --image descarga.jpg")
imagen = interfazWebUART.shared_queue.get()

print(imagen)