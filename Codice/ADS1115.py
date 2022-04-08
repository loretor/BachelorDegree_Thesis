import board
import busio
import adafruit_ads1x15.ads1015 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
import time

# settaggio del bus i2c
# i2c = busio.I2C(board.SCL, board.SDA)
i2c = board.I2C()

# creiamo l'oggetto ads a partire dal bus
ads = ADS.ADS1015(address = 0x48, i2c=i2c)

# usiamo i 4 canali dell'ads
chan1 = AnalogIn(ads, ADS.P0)
chan2 = AnalogIn(ads, ADS.P1)
chan3 = AnalogIn(ads, ADS.P2)
chan4 = AnalogIn(ads, ADS.P3)

while True:
    print("CH0: %f CH1: %f CH2: %f CH3: %f" % (chan1.voltage,chan2.voltage,chan3.voltage,chan4.voltage))
    time.sleep(1)