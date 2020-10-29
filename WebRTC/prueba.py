#!/usr/bin/python
# -*- coding: utf-8 -*-

import cgi, cgitb, os, sys


UPLOAD_DIR = './upload'

def save_uploaded_file():
    print 'Content-Type: text/html; charset=UTF-8'
    print
    print '''
<html>
<head>
  <title>Upload File</title>
</head>
<body>
'''

    form = cgi.FieldStorage()
    if not form.has_key('file'):
        print '<h1>Not found parameter: file</h1>'
        return

    form_file = form['file']
    if not form_file.file:
        print '<h1>Not found parameter: file</h1>'
        return

    if not form_file.filename:
        print '<h1>Not found parameter: file</h1>'
        return

    uploaded_file_path = os.path.join(UPLOAD_DIR, os.path.basename(form_file.filename))
    with file(uploaded_file_path, 'wb') as fout:
        while True:
            chunk = form_file.file.read(100000)
            if not chunk:
                break
            fout.write (chunk)
    print '<h1>Completed file upload</h1>'

    print '''
<hr>
<a href="../upload.html">Back to upload page</a>
</body>
</html>
'''


cgitb.enable()
save_uploaded_file()



































# import argparse
# import cv2
# import numpy as np
# import time
# import requests
# import os

# path_img= 'descarga.jpg'
# url = 'http://localhost:5500/prueba.html'
# with open(path_img, 'rb') as img:
#   name_img= os.path.basename(path_img)
#   files= {'image': (name_img,img,'multipart/form-data',{'Expires': '0'}) }
#   with requests.Session() as s:
#     r = s.post(url,files=files)
#     print(r.status_code)