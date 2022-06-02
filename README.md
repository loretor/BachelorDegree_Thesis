# Progetto di Tesi con Raspberry
Creazione di una serra automatica con la scheda Raspberry

# Componenti del gruppo di lavoro
- Matteo Carminati
- Lorenzo Torri

# Organizzazione della repository
Nella cartella [Modelli](/Modelli) sono presenti le rappresentazioni mediante UML del progetto. Per ora l'unica rappresentazione creata è quella di uno StateChart Diagram.

Nella cartella [Codice](/Codice) sono presenti tutti i file .py creati per controllare sensori e attuatori tramite Raspberry. In particolare sono presenti i singoli file python che sono stati usati per controllare singolarmente i sensori e per chiudere ed aprire il circuito che collega rasperry alla scheda relais.

Il file [controller.py](Codice/controller.py) è la prima versione di codice python che verrà utilizzato per poter controllare raspberry e poter permettere alla scheda di svolgere più attività e controllare lo scheduling di queste ultime.

# Spiegazione controller.py
Il file è ancora abbastanza confuso; in futuro l'idea è quella di suddividere ogni classe in un file python proprio, di modo tale poi da avere una migliore organizzazione del progetto. 
Il flow di controllo del rapsberry è fortemente influenzato dallo StateChart presente nella cartella [Modelli](/Modelli).
Per ora siamo riusciti a implementare tramite codice solamente la parte interna allo stato "Luce accesa", focalizzandoci sullo scheduling delle due diverse attività di lettura del sensore DTH22 (per la temperatura e umidità dell'aria) e del sensore Capacitive Soil Moisture (per la temperatura del suolo).
Queste due attività sono state implementate con dei thread che condividono un lock per la risorsa condivisa. 
``` 
class Thread_paralleli(Thread):
    def __init__(self, activity, identificativo):
        Thread.__init__(self)
        self.activity = activity
        self.identificativo = identificativo

    def run(self):
        global mutex
        global q

        while True:
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
```

L'idea è infatti quella di alternare la lettura prima di un sensore (thread1) e poi quella del secondo sensore (thread2), di modo tale che poi sempre nel momento in cui ogni thread possiede il lock possa eventualmente azionare degli attuatori qualora sulla base della propria lettura sia necessario intervenire sulla serra (esempio: DHT22 legge una nuova temperatura, calcola la media delle ultime temperature lette e osserva che la temperatura media è troppo alta per la serra, per cui chiude il circuito della scheda relais e attiva la ventola per poter permettere un recircolo d'aria; una volta terminato rilascia il lock per permettere al Capacitive di proseguire con la sua lettura).

