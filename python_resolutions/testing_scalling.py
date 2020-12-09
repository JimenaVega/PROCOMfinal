# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 18:10:30 2020
for testing purposes

@author: J
"""
n = input("Numeros a generar : ")
file = open("generateNum.txt","w")

for i in range(int(n)):
    file.write("#{0} convValue = {1};\n".format((10),i))
    
file.close()
 
