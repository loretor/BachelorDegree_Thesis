#modulo che contiene tutti i collegamenti da fare per ogni sensore o attuatore collegato alla scheda relais
# libreria per dht
import Adafruit_DHT as dht

# librerie per ads e capcitive soil moisture sensor
import board
import busio
import adafruit_ads1x15.ads1015 as ADS
from adafruit_ads1x15.analog_in import AnalogIn


#per lettura valori del sensore DHT22
def dht22():
    DHT = 21
    h,t = dht.read_retry(dht.DHT22, DHT)
    return h,t


# funzione che usiamo solo localmente in questo modulo
# la funzione serve per trasformare il valore letto dal capacitive in un valore in % di umidità
def map(x, in_min, in_max, out_min, out_max):
    return int((x-in_min) * (out_max - out_min) / (in_max - in_min) + out_min)


#per lettura valori del Capacitive soil moisture sensor
def capacitive():
    #attvitià del capacitive
    i2c = busio.I2C(board.SCL, board.SDA)
    #creiamo l'oggetto ads a partire dal bus
    ads = ADS.ADS1015(i2c)
    #usiamo i 4 canali dell'ads
    chan1 = AnalogIn(ads, ADS.P0)
    chan2 = AnalogIn(ads, ADS.P1)
    chan3 = AnalogIn(ads, ADS.P2)
    chan4 = AnalogIn(ads, ADS.P3)

    print('CAPACITIVE')
    #valore = random.randint(0,100)
    umidita = (map(chan1.voltage, 2.990091, 0.604018, 40, 100))

    return umidita
