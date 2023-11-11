import sys
import os
import serial
import argparse as p
from funciones import armadoInstruc
from funciones import configprint
from rich import print
from rich.console import Console

def case_step(ser,input_char):
       ser.write(input_char.encode())
       return 'STEP'

def case_continuos(ser,input_char):
    ser.write(input_char.encode())
    return 'CONTINUOUS'

def case_exit(ser,input_char):
    print("##### Has seleccionado la opcion salir #####")
    sys.exit()

def default(ser,input_char):
    print("##### [ERROR] opcion no valida,  Ingrese s (STEP) c (CONTINUOUS) e (EXIT) #####")
    return 'IDLE'
#Defino los casos
cases = {
    's': case_step,
    'c': case_continuos,
    'e': case_exit
}

# module support for command-line interfaces is built around an instance of argparse
data_flags = p.ArgumentParser(description='Debug')

# Creamos los flags para aportar argumentos posicionales, opciones que aceptan valores, y banderas de activacion y desactivacion
data_flags.add_argument('-p', '--serial', type=str, help='serial port', default='/COM4')
data_flags.add_argument('-d', '--memory', type=int, help='data memory', default=16)
data_flags.add_argument('-r', '--reg', type=int, help='register file', default=32)


# Obtengo los valores
args = data_flags.parse_args()
file = "entrada.asm"
binarios = "entrada.bin"
memory_val = args.memory
register_val = args.reg
serial_port = args.serial

def main():
    ser = serial.Serial(serial_port, 9600)
    mode = 'IDLE'
    console = Console()
    print(f"##### Asm a enviar: {file} - Puerto: {serial_port} - Baudios: 9600 #####")
    # Se convierte a binario las intrucciones ASM
    ins_count = armadoInstruc.create_bin(file, binarios)
    # Envio de instrucciones
    armadoInstruc.send(binarios, ser)

    while True:
        if (mode == 'IDLE'):
            console.print("Ingrese s (STEP) c (CONTINUOUS) e (EXIT) #####",style="bold red")
            input_char = input("##### :")
            previous_data = 0;

            #segun la letra ignresa se obtiene el modo
            mode = cases.get(input_char, default)(ser,input_char)
        elif (mode == 'STEP'):
            console.print("MODO STEP",style="bold red")

            # n siguiente step cuando estoy en modo step
            while (input_char != 'e'):
                console.print("##### presione n para el siguiente step #####",style="bold red")
                input_char = input("##### :")
                if (input_char == 'n'):
                    ser.write(input_char.encode())
                    data_received, err = armadoInstruc.receive_result(ser, 50)
                    if(err == 1):
                        mode = 'IDLE'
                        break
                    else:
                        console.print("#############################################",style="bold red")
                        configprint.print_data_dif( data_received, previous_data, register_val,memory_val)
                        previous_data = data_received

            sys.exit()
        elif (mode == 'CONTINUOUS'):

            console.print("##### MODO CONTINUO #####",style="bold red")
            input_char == 'c'
            ser.write(input_char.encode())
            data_received, err = armadoInstruc.receive_result(ser, 50)
            configprint.print_data(data_received , register_val ,memory_val)
            mode = 'IDLE'


if __name__ == "__main__":
    main()

