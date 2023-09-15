import time


def tx(program_file, serial):
    # Send l to start write the memory
    print('Loading...')
    serial.write('l'.encode())  #envio para cargar data
    time.sleep(0.1)
    with open(program_file, 'rb') as file:
        data = file.read().replace(b'\r\n', b'')
        #data = file.read().replace(b'\r', b'')
        num_byte = []
        #print (data)
        for i in range(int(len(data)/8)):
            #print (data[i*8:(i+1)*8])
            num = int(data[i*8:(i+1)*8], 2).to_bytes(1, byteorder='big')
            print (num)
            serial.write(num)
            time.sleep(0.05)
            #time.sleep(1)

def receive_data(serial, n):
    response = b''
    word_counter = 0
    error = 0
    time.sleep(2)
    while word_counter < n*4:
        if serial.in_waiting != 0:
            response += serial.read()
            print (response)
            word_counter += 1
            error = 0;
        else:
            time.sleep(0.1)  # Wait for more data
            error += 1
            if(error == 5):
                return response, 1
    return response, 0

def ascii_a_binario(letra):
    # Int
    valor = ord(letra)
    return "{0:08b}".format(valor)


def binario_a_decimal(binario):
    posicion = 0
    decimal = 0
    # Invertir la cadena porque debemos recorrerla de derecha a izquierda
    binario = binario[::-1]
    for digito in binario:
        # Elevar 2 a la posición actual
        multiplicador = 2**posicion
        decimal += int(digito) * multiplicador
        posicion += 1
    return decimal

def to_hexadecimal(value):
    decimal = int(value, 2)
    hexadecimal = hex(decimal)
    return hexadecimal

def recibir(ser):
     #ser = serial.Serial('COM4', 38400)
     ser.timeout = 5

     while True:
          received_data = ser.read(1)
          if ((received_data) and (received_data != b'\n')):
               print(f'\rbinary: {ascii_a_binario(received_data)}\t'
               f'Decimal: {binario_a_decimal(ascii_a_binario(received_data))}\t'
               f'Hex:{to_hexadecimal(ascii_a_binario(received_data))}\t\n',
               end='')
               #ser.close()
               #break