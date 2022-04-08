import threading, queue

lista_valori_dht22_temperatura = queue.Queue(40)
lista_valori_dht22_umidita = queue.Queue(40)
lista_valori_capacitive = queue.Queue(40)

M_temperatura_aria = 0
M_umidita_aria = 0
M_umidita_suolo = 0

#sottoclasse di Thread che ha come cosa aggiuntiva un campo priorità
class PriorityThread(threading.Thread):
    #override del metodo __init__ di Thread
    def __init__(self, priority):
        super(PriorityThread, self).__init__()
        self.priority = priority
        return

#metodo per aggiornare il valore di una media e la lista degli ultimi valori letti da un sensore
def update_M(lista, M, valore):
    #se la lista è piena bisogna togliere il più vecchio valore letto (politica FIFO) e aggiornare la media
    if lista.full():
        y = lista.get()
        M = (lista.qsize() * M - y) / (lista.qsize() - 1)
    #se la lista non è piena o è terminato l'if basta aggiungere il valore e aggiornare la media
    lista.put(valore)
    M = ((lista.qsize() - 1) * M + valore) / lista.qsize()


#funzione attività del sensore DTH22, per misura umidità aria e temperatura
def activity_DHT22():
    #corpo

#funzione attività del sensore HCSR04, per distanza da galleggiante
def activity_HCSR04():
    #corpo

#funzione attività del sensore Capacitive Soil Moisture, per umidità suolo
def activity_Capacitive():
    #corpo


def main():
    t1 = PriorityThread(target = activity_DHT22(), priority = 1)
    t2 = PriorityThread(target = activity_HCSR04(), priority = 2)
    t2 = PriorityThread(target = activity_Capacitive(), priority = 3)

    t1.start()
    t2.start()
    t3.start()

if __name__ = '__main__':
    main()
