from threading import Thread
import time
from datetime import datetime, timedelta

#thread padre
class Thread_padre(Thread):
    def __init__(self, identificativo):
        Thread.__init__(self)
        self.identificativo = identificativo

    def run(self):
        i = 0
        while i < 2:
            print("I am the father")
            t1 = Thread_paralleli(identificativo = "DHT22" )
            t2 = Thread_paralleli(identificativo = "Capacitive" )

            #if (t1.is_alive() and t2.is_alive()):
            print("Ho acceso le luci")

            t1.start()
            t2.start()

            t1.join()
            t2.join()

            print("Spegni le luci")
            i = i +1

            orario_attuale = datetime.now()
            print(orario_attuale)

            confronto = datetime.now()
            confronto += timedelta(days = 1)
            confronto = confronto.replace(hour = 7, minute = 0, second = 0)


            print(confronto)

            while orario_attuale < confronto:
                print("Sto dormendo...")
                time.sleep(2)
                orario_attuale = datetime.now()


#thread figli
class Thread_paralleli(Thread):
    def __init__(self, identificativo):
        Thread.__init__(self)
        self.identificativo = identificativo

    def run(self):
        print("I'm Thread "+self.identificativo)
        i = 0
        c = 5
        while i < c:
            print(self.identificativo + " " +str(i))
            i = i + 1


t = Thread_padre(identificativo = "padre" )
t.start()
