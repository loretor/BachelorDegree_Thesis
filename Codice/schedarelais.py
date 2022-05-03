import RPi.GPIO as GPIO
import time

# per settare la nomenclatura dei GPIO
GPIO.setmode(GPIO.BCM)
# GPIO.cleanup()

GPIO.setwarnings(False)
# settaggio pin che vogliamo usare con la nomenclatura bcm
GPIO.setup(17, GPIO.OUT)

while(1):
    GPIO.output(17, GPIO.HIGH)
    time.sleep(5)
    GPIO.output(17, GPIO.LOW)
    time.sleep(5)
