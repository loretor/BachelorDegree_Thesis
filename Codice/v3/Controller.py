from pickle import TRUE
from tempfile import TemporaryDirectory
from threading import Thread
import time
from datetime import datetime, timedelta

import ThreadParalleli as figli
import Relais as rel

GPIO_luci = 23

#thread padre
class Thread_padre(Thread):
    def __init__(self, identificativo):
        Thread.__init__(self)
        self.identificativo = identificativo

    def run(self):
        print("I am the father")
       
        while TRUE:
            t1 = figli.Thread_paralleli(activity = figli.activity_DHT22, identificativo = "DHT22" )
            t2 = figli.Thread_paralleli(activity = figli.activity_Capacitive, identificativo = "Capacitive" )

            t1.start()
            t2.start()
            
            #luci accese, T1 e T2 lavorano
            rel.relais_ON_luce(GPIO_luci)
            orario_attuale = datetime.now()
            print(orario_attuale)
            confronto_sera = orario_attuale.replace(hour = 15, minute = 29, second = 0)
            
            #faccio dormire il thread luci, continuano T1 e T2 (sono tra le 7 e le 20)
            while orario_attuale < confronto_sera:
                print("Sto dormendo...")
                time.sleep(2)
                orario_attuale = datetime.now() 

            orario_attuale = datetime.now() 
            #print(orario_attuale)

            confronto_mattina = datetime.now()
            #confronto_mattina += timedelta(days = 1)
            confronto_mattina = confronto_mattina.replace(hour = 15, minute = 30, second = 0)
            
            # per sicurezza si aprono tutti i circuiti della scheda relais per evitare che qualche attuatore rimanga attivo
            rel.relais_OFF()
            #stoppo T1 e T2 e spengo luci (siamo tra le 20 e le 7)
            rel.relais_OFF_luce(GPIO_luci)
            #faccio dormire il thread luci,  T1 e T2 sono stoppati
            while orario_attuale < confronto_mattina:
                print("Sto dormendo...")
                time.sleep(10)
                orario_attuale = datetime.now()


t = Thread_padre(identificativo = "padre" )
t.start()
