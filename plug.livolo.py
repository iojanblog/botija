import time
import sys
import RPi.GPIO as GPIO

off = '1242424352424342424242424242425342524342'
b0 = '12424243524243424242424242424242424242424242'
b1 = '124242435242434242424242424242534242424242'
b2 = '1242424352424342424242424242425353424242'
b3 = '124242435242434242424242424242424253424242'
b4 = '124242435242434242424242424242524342424242'
b5 = '124242435242434242424242424242425342424242'
b6 = '1242424352424342424242424242425342534242'
b7 = '124242435242434242424242424242424242534242'
b8 = '124242435242434242424242424242524243424242'
b9 = '124242435242434242424242424242425243424242'

if sys.argv[1:] == 'off':
    NUM_ATTEMPTS = 1300
else:
    NUM_ATTEMPTS = 170

TRANSMIT_PIN = 17

def transmit_code(code):
    '''Transmit a chosen code string using the GPIO transmitter'''
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(TRANSMIT_PIN, GPIO.OUT)
    for t in range(NUM_ATTEMPTS):
        for i in code:
            if i == '1':
                GPIO.output(TRANSMIT_PIN, 1)
                time.sleep(.00055);
                GPIO.output(TRANSMIT_PIN, 0)
            elif i == '2':
                GPIO.output(TRANSMIT_PIN, 0)
                time.sleep(.00011);
                GPIO.output(TRANSMIT_PIN, 1)
            elif i == '3':
                GPIO.output(TRANSMIT_PIN, 0)
                time.sleep(.000303);
                GPIO.output(TRANSMIT_PIN, 1)
            elif i == '4':
                GPIO.output(TRANSMIT_PIN, 1)
                time.sleep(.00011);
                GPIO.output(TRANSMIT_PIN, 0)
            elif i == '5':
                GPIO.output(TRANSMIT_PIN, 1)
                time.sleep(.00029);
                GPIO.output(TRANSMIT_PIN, 0)
            else:
                continue
        GPIO.output(TRANSMIT_PIN, 0)
    GPIO.cleanup()

if __name__ == '__main__':
    for argument in sys.argv[1:]:
        exec('transmit_code(' + str(argument) + ')')