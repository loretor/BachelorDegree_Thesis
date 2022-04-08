import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

# GPIO23 significa il pin 16 a partire da in alto a sinistra
# GPIO24 significa il pin 18 a partire da in alto a sinistra
TRIG = 23
ECHO = 24

print("Distance Measurement in progress")

while(True):
    GPIO.setwarnings(False)
    GPIO.setup(TRIG, GPIO.OUT)
    GPIO.setup(ECHO, GPIO.IN)

    # siamo sicuri che il trigger sia a false
    GPIO.output(TRIG, False)
    print("Waiting for sensor to settle")
    time.sleep(2)

    # il segnale in ingresso necessita di un impulso di 10uS
    GPIO.output(TRIG, True)
    time.sleep(0.00001)
    GPIO.output(TRIG, False)

    while GPIO.input(ECHO) == 0:
        pulse_start = time.time()

    while GPIO.input(ECHO) == 1:
        pulse_end = time.time()
        
    # calcolo del tempo che impiega il segnale ad andare e tornare contro l'oggetto
    pulse_duration = pulse_end - pulse_start

    # velocità del suono è uguale a 34300 cm/s e il tempo è metà in quanto deve fare andata e ritorno
    distance = pulse_duration * 34300/2
    distance = round(distance, 2)
    print("Distance ", distance,"cm")
    
    time.sleep(1)


GPIO.cleanup()


