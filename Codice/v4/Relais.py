import RPi.GPIO as GPIO
import time

# funzione da richiamare per gestire la scheda relais nel caso di pompe e ventola
def relais_attuatori(num_porta, tempo):
    # per settare la nomenclatura dei GPIO
    GPIO.setmode(GPIO.BCM)
 
    GPIO.setwarnings(False)
    # settaggio pin che vogliamo usare con la nomenclatura bcm
    GPIO.setup(num_porta, GPIO.OUT)
    
    GPIO.output(num_porta, GPIO.LOW)
    time.sleep(tempo)
    GPIO.output(num_porta, GPIO.HIGH)


# funzione da richimare per attivare la scheda relais per le luci
def relais_ON_luce(num_porta):
    # per settare la nomenclatura dei GPIO
    GPIO.setmode(GPIO.BCM)

    GPIO.setwarnings(False)
    # settaggio pin che vogliamo usare con la nomenclatura bcm
    GPIO.setup(num_porta, GPIO.OUT)
    
    GPIO.output(num_porta, GPIO.LOW)


# funzione da richimare per spegnere la scheda relais per le luci
def relais_OFF_luce(num_porta):
    # per settare la nomenclatura dei GPIO
    GPIO.setmode(GPIO.BCM)

    GPIO.setwarnings(False)
    # settaggio pin che vogliamo usare con la nomenclatura bcm
    GPIO.setup(num_porta, GPIO.OUT)
    
    GPIO.output(num_porta, GPIO.HIGH)
    
# funzione per spegnere tutti i circuiti della relais (tranne le luci che viene fatto da relais_OFF_luce)
def relais_OFF():
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(17, GPIO.OUT)
    GPIO.setup(27, GPIO.OUT)
    GPIO.setup(22, GPIO.OUT)
    GPIO.setup(24, GPIO.OUT)
    
    GPIO.output(17, GPIO.HIGH)
    GPIO.output(27, GPIO.HIGH)
    GPIO.output(22, GPIO.HIGH)
    GPIO.output(24, GPIO.HIGH)
