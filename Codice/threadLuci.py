from pickle import TRUE
from tempfile import TemporaryDirectory
from threading import Thread
import time
from datetime import datetime, timedelta

#thread padre
class Thread_padre(Thread):
    def __init__(self, identificativo):
        Thread.__init__(self)
        self.identificativo = identificativo

    def run(self):
        print("I am the father")
       
        while TRUE:
            t1 = Thread_paralleli(identificativo = "DHT22" )
            t2 = Thread_paralleli(identificativo = "Capacitive" )

            t1.start()
            t2.start()
            #luci accese, T1 e T2 lavorano
            print("Ho acceso le luci")
            orario_attuale = datetime.now()
            confronto_sera = orario_attuale.replace(hour = 12, minute = 5, second = 0)
            #faccio dormire il thread luci, continuano T1 e T2 (sono tra le 7 e le 20)
            while orario_attuale < confronto_sera:
                print("Sto dormendo...")
                time.sleep(2)
                orario_attuale = datetime.now() 

            orario_attuale = datetime.now() 
            print(orario_attuale)

            confronto_mattina = datetime.now()
           #confronto_mattina += timedelta(days = 1)
            confronto_mattina = confronto_mattina.replace(hour = 12, minute = 6, second = 0)
#SPEGNI PIN SCHEDA REALAIS
            #stoppo T1 e T2 e spengo luci (siamo tra le 20 e le 7)
            print(confronto_mattina)
            print("Spegni le luci")
            #faccio dormire il thread luci,  T1 e T2 sono stoppati
            while orario_attuale < confronto_mattina:
                print("Sto dormendo...")
                time.sleep(10)
                orario_attuale = datetime.now()

#thread figli
class Thread_paralleli(Thread):
    def __init__(self, identificativo):
        Thread.__init__(self)
        self.identificativo = identificativo

    def run(self):
        print("I'm Thread "+self.identificativo)
        i = 0
        orario_attuale = datetime.now()
        confronto = orario_attuale.replace(hour = 12, minute = 5, second = 0)
        while orario_attuale<confronto:
            time.sleep(3)
            print(self.identificativo + " " +str(i))
            i = i + 1
            orario_attuale = datetime.now()
    
    def dormi(self, tempo):
        time.sleep(tempo)


t = Thread_padre(identificativo = "padre" )
t.start()
