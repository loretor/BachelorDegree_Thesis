import Adafruit_DHT as dht
import time

# usiamo come pin il GPIO4 che coincide con il pin 7
DHT = 4

while True:
    h,t = dht.read_retry(dht.DHT22, DHT)
    print("Temp = {0:0.1f}*C Humidity = {1:0.1f}%".format(t,h))
    time.sleep(5)
