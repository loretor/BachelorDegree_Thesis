from threading import Thread, RLock
import time, queue, random
import time
from datetime import datetime, timedelta

#import dei vari moduli presenti nella stessa cartella di Controller.py
import Pila as pila
import UpdateQueue as uq
import Circuits as cir
import Relais as rel

#variabili globali
mutex = RLock()
q = pila.pila()

Listdimension = 5

#liste per fare una media di un certo numero di valori e non considerare solo il singolo
lista_valori_dht22_temperatura = queue.Queue(Listdimension)
lista_valori_dht22_umidita = queue.Queue(Listdimension)
lista_valori_capacitive = queue.Queue(Listdimension)

#valori di riferimento per prendere decisioni
M_temperatura_aria = 0
M_umidita_aria = 0
M_umidita_suolo = 0

# valori costanti
Max_umidita_aria = 60
Min_umidita_aria = 50
Min_umidita_suolo = 40
countIrrigazioni = 0
numeroIrrigazioni = 2 # dopo quante irrigazioni bisogna fertilizzare
altezzariferimento_vuoto = 12

# numero di porte GPIO per gli attuatori
GPIO_pompa_irrigazione = 17
GPIO_pompa_umidificazione = 27
GPIO_pompa_fertilizzante = 22
GPIO_ventola = 24

# tempi di attesa per il funzionamento dei vari attuatori
time_irrigazione = 10
time_umidificazione = 10
time_fertilizzante = 10
time_ventola = 10

#classe Thread paralleli
class Thread_paralleli(Thread):
    def __init__(self, activity, identificativo):
        Thread.__init__(self)
        self.activity = activity
        self.identificativo = identificativo

    def run(self):
        global mutex
        global q

        orario_attuale = datetime.now()
        #mettere come tempo 5 minuti prima delle 20, di modo tale da evitare problemi di sincronizzazione con il thread padre che
        #termina alle 20         
        confronto = orario_attuale.replace(hour = 16, minute = 19, second = 0)
        
        #il run del thread viene fatto solo quando l'orario è prima delle 20:00      
        while orario_attuale < confronto:
            mutex.acquire()

            #se siamo nella situazione di lista vuota dobbiamo inserire il thread nella lista di attesa
            if(q.length() == 0):
                #se però il thread è già stato servito per ultimo secondo la lista, allora non lo metteremo in attesa perchè vogliamo evitare di servirlo due volte di fila
                #se infatti il t1 è più veloce di t2 e verifica due volte di fila questa condizione q.length == 0 rischia di fare due volte di fila le sue attività cosa che non vogliamo
                #quindi questo spiega il perchè serve avere il lastpop, di modo tale che fino a che t1 è l'ulitmo a essere stato poppato non può prendersi il lock
                if(q.lastpop != self.identificativo):
                    q.push(self.identificativo)

            #queste attività possono essere fatte solo se la lista ha degli elementi
            if(q.length() != 0):
                #se il thread è in testa alla lista allora eseguo le sue attività e lo tolgo dalla lista
                if(q.head() == self.identificativo):
                    self.activity()
                    q.pop()
                #se invece non è in testa, allora controllo quante istanze di lui ci sono nella lista, se il valore è 0 allora posso metterlo, se è diverso da 0 vuol dire che è 1
                #e significa che è già nella lista e non devo scriverlo ancora, se no lo ripeto nella lista
                else:
                    count = q.search(self.identificativo)
                    if(count == 0):
                        q.push(self.identificativo)

            mutex.release()
            #la dormita è solo per rendere la simulazione più lenta se no non si vede niente
            time.sleep(2)
            orario_attuale = datetime.now()


def activitycaso(stringa):
    print("sto facendo l'attività "+str(stringa))

## funzione attività del sensore DTH22, per misura umidità aria e temperatura
def activity_DHT22():
    global M_temperatura_aria
    global M_umidita_aria

    #try perchè potrebbe accadere che a volte la lettura del valore non vada a buon fine, e per evitare che il sistema si interrompa, tralasciamo tale misurazione
    try:
        #lettura valori
        h,t = cir.dht22()

        print('DHT22')
        #aggiorno la lista_valori_dht22_temperatura e la M_temperatura_aria
        #t = random.randint(0,22)
        M_temperatura_aria = uq.update_M(lista_valori_dht22_temperatura, M_temperatura_aria, t)
        M_umidita_aria = uq.update_M(lista_valori_dht22_umidita, M_umidita_aria, h)

        #controllo attività
        #le attività possono essere svolte solo se l'array dei valori è pieno
        if(lista_valori_dht22_umidita.full()):
            #Umidificazione
            if M_umidita_aria < Min_umidita_aria:
                #accendiamo la scheda
                print("UMIDIFICAZIONE")
                rel.relais_attuatori(GPIO_pompa_umidificazione, time_umidificazione)
                
                #azzeriamo le medie e svuotiamo gli array
                uq.clearList(lista_valori_dht22_temperatura)
                uq.clearList(lista_valori_dht22_umidita)
                uq.clearList(lista_valori_capacitive)
                M_temperatura_aria = 0
                M_umidita_aria = 0
                M_umidita_suolo = 0
                
                altezza_vuoto = cir.hcsr()
                print(altezza_vuoto)
#                 if altezza_vuoto > altezzariferimento_vuoto:
                    #AGGIUNGERE VARIABILE NEL FILE JSON CHE DICE CHE SERVE AGGIUNGERE ACQUA 
                
            #Ventilazione Alta
            elif M_umidita_aria > Max_umidita_aria:
                #accendiamo la scheda
                print("VENTILAZIONE")
                rel.relais_attuatori(GPIO_ventola, time_ventola)
                
                #azzeriamo le medie e svuotiamo gli array
                uq.clearList(lista_valori_dht22_temperatura)
                uq.clearList(lista_valori_dht22_umidita)
                uq.clearList(lista_valori_capacitive)
                M_temperatura_aria = 0
                M_umidita_aria = 0
                M_umidita_suolo = 0
    except:
        pass

    print(list(lista_valori_dht22_umidita.queue))
    print("M: "+str(M_umidita_aria))
    print("--------------------")
    print(list(lista_valori_dht22_temperatura.queue))
    print("M: "+str(M_temperatura_aria))
    print("--------------------")


## funzione attività del sensore Capacitive Soil Moisture, per umidità suolo
def activity_Capacitive():
    global M_umidita_suolo
    global countIrrigazioni

    #try perchè potrebbe accadere che a volte la lettura del valore non vada a buon fine, e per evitare che il sistema si interrompa, tralasciamo tale misurazione
    try:
        #lettura del valore
        umidita = cir.capacitive()
        M_umidita_suolo = uq.update_M(lista_valori_capacitive, M_umidita_suolo, umidita)

        #controllo attività
        #le attività possono essere svolte solo se l'array dei valori è pieno
        if lista_valori_capacitive.full():
            #bisogna Irrigare perchè l'umidità del suolo è troppo bassa
            if M_umidita_suolo < Min_umidita_suolo:
                #accendiamo la scheda
                print("IRRIGAZIONE")
                rel.relais_attuatori(GPIO_pompa_irrigazione, time_irrigazione)
                
                #aggiorniamo il conteggio delle irrigazioni              
                countIrrigazioni += 1

                #azzeriamo le medie e svuotiamo gli array
                uq.clearList(lista_valori_capacitive)
                M_umidita_suolo = 0
                
                #se il numero di irrigazioni arriva a un tot allora si fertilizza e si azzera
                if countIrrigazioni >= numeroIrrigazioni:
                    print("FERTILIZZAZIONE")
                    countIrrigazioni = 0
                    #accendiamo la scheda
                    rel.relais_attuatori(GPIO_pompa_fertilizzante, time_fertilizzante)
                
                altezza_vuoto = cir.hcsr()
                print(altezza_vuoto)
                #if altezza_vuoto > altezzariferimento_vuoto:
                #AGGIUNGERE VARIABILE NEL FILE JSON CHE DICE CHE SERVE AGGIUNGERE ACQUA 
               
               

        print(list(lista_valori_capacitive.queue))
        print("M: "+str(M_umidita_suolo))
        print("--------------------")
    except:
        pass

