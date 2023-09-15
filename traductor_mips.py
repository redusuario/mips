import sys
import serial
import os
from funciones import conversor
from funciones import send

print ("Ingrese el nombre del archivo con las intrucciones, puerto")
file = sys.argv[1]
puerto = sys.argv[2]
file_bin = os.path.splitext(file)[0] + ".bin"
ser = serial.Serial(puerto, 38400)	

print("Nombre del script:", file)

ins_count = conversor.create_raw_file(file, file_bin)

send.tx(file_bin, ser)


#send.receive_data(ser, 50)

send.recibir(ser)
