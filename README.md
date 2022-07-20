# Progetto di Tesi con Raspberry 👨‍💻
Creazione di una serra automatica con la scheda Raspberry

# 🧑‍💻 Componenti del gruppo di lavoro
- Matteo Carminati
- Lorenzo Torri

# 📂 Organizzazione della repository
Nella cartella [Modelli](/Modelli) sono presenti le rappresentazioni UML del progetto. Per ora l'unica rappresentazione creata è quella di uno StateChart Diagram.

Nella cartella [Codice](/Codice) sono presenti tutti i file .py creati per controllare sensori e attuatori tramite Raspberry. In particolare sono presenti i file python che sono stati usati per controllare singolarmente i sensori e per chiudere ed aprire il circuito che collega rasperry alla scheda relais.

Nella cartella [Codice/v4](/Codice/v4) è presente tutto il codice necessario per controllare raspberry, con una suddivisione in vari moduli per poter organizzare meglio tutto il codice.

Il file [controller.py](Codice/controller.py) è il cuore del controlloro di raspberry per poter permettere alla scheda di svolgere più attività e controllare lo scheduling di queste ultime.

# 📡 Spiegazione controller.py
Il flow di controllo del rapsberry è fortemente influenzato dallo StateChart presente nella cartella [Modelli](/Modelli).
Il ciclo di attività della serra è 08:00/20:00. Nel file controller.py viene attivato un Thread che controlla l'accensione delle luci per la serra. In particolare l'accensione segue esattamente il ciclo di attività mostrato sopra. Tra le 20:00 e le 08:00 il thread spegne le luci e viene momentaneamente addormentato.
Durante il ciclo, invece, vengono creati due thread che si occupano delle attività di controllo della serra con la lettura dei valori dei sensori e l'eventuale accensione o spegnimento degli attuatori per regolare le variabili ambiente.
(Per ora gli orari non sono corretti, in quanto rispecchiano i test che stiamo svolgendo per verificare il corretto funzionamento del sistema).
```python
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
            confronto_sera = orario_attuale.replace(hour = 16, minute = 20, second = 0)

            #faccio dormire il thread luci, continuano T1 e T2 (sono tra le 7 e le 20)
            while orario_attuale < confronto_sera:
                print("Sto dormendo...")
                time.sleep(30)
                #inviamo i dati al cloud
                chiamata_Http()
                orario_attuale = datetime.now()

            orario_attuale = datetime.now()
            #print(orario_attuale)

            confronto_mattina = datetime.now()
            #confronto_mattina += timedelta(days = 1)
            confronto_mattina = confronto_mattina.replace(hour = 16, minute = 21, second = 0)

            # per sicurezza si aprono tutti i circuiti della scheda relais per evitare che qualche attuatore rimanga attivo
            rel.relais_OFF()
            #stoppo T1 e T2 e spengo luci (siamo tra le 20 e le 7)
            rel.relais_OFF_luce(GPIO_luci)
            #faccio dormire il thread luci,  T1 e T2 sono stoppati
            while orario_attuale < confronto_mattina:
                print("Sto dormendo...")
                time.sleep(10)
                orario_attuale = datetime.now()
```

Queste due attività sono state implementate con dei thread che condividono un lock per la risorsa condivisa. Ogni attività di lettura dei due sensori si basa su una lista di misurazioni. In particolare ognuno dei due thread ha associato una [queue](https://docs.python.org/3/library/queue.html) di valori, tale per cui ogni volta che il sensore legge un valore lo inserisce nella sua queue. Se la queue è piena si elimina il valore più vecchio che è stato letto dal sensore e si aggiunge il nuovo (politica FIFO). 
E' stata scelta questa gestione dei valori letti da un sensore per rendere statisticamente più valide le misurazioni. Infatti può accadere (data la scarsa qualità di alcuni sensori) che ci possano essere delle letture errate o che non si misurino correttamente dei dati. Per rendere quindi tali misurazioni il meno impattanti possibili sul controllore, è necessario aumentare il numero di campioni e lavorare sempre sulla media di questi ultimi.

Questa è la porzione di codice del controllore che gestisce l'aggiunta di un nuovo elemento alla lista con l'aggiornamento della media di quest'ultima.
```python
#metodo per aggiornare il valore di una media e la lista degli ultimi valori letti da un sensore
def update_M(lista, M, valore):
    media = M
    #se la lista è piena bisogna togliere il più vecchio valore letto (politica FIFO) e aggiornare la media
    if lista.full():
        y = lista.get()
        media = ((lista.qsize()+1) * media - y) / (lista.qsize())

    #se la lista non è piena o è terminato l'if basta aggiungere il valore e aggiornare la media
    lista.put(valore)
    if (lista.qsize() == 0):
        media = valore
    else:
        media = ((lista.qsize() - 1) * media + valore) / lista.qsize()

    return media
```

Riportiamo il codice dove sono presenti le queue per i due sensori e le loro medie. Inoltre sono presenti anche altre variabili necessarie per i controlli che regolano l'eventuale azionamento della scheda relais. Per ora la grandezza di queste queue è di 5 elementi perchè nelle nostre fasi di testing era necessario controllare più velocemente il corretto funzionamento del Rapsberry. In futuro la grandezza delle liste sarà molto più grande.
```python
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
# dopo quante irrigazioni bisogna fertilizzare
numeroIrrigazioni = 2
```

La gestione dei thread è abbastanza classica, infatti seguendo lo Statechart abbiamo creato due diversi thread con una classe build di Python con associata l'attività che il thread deve svolgere.
Spieghiamo prima come sono creati i thread e poi come abbiamo gestito il loro scheduling.
I thread hanno associata una funzione che rappresenta il loro task da svolgere. La funzione sia nel caso di DHT22 che nel caso del Capacitive Soil Moisture Sensor consiste:
- porzione di codice dove si setta il collegamento tra raspberry e il sensore per ottenere il dato (è uno dei file .py presenti nella cartella Codici che abbiamo integrato in questa funzione specifica.
- aggiorna i valori della prorpia queue con il metodo visto in precedenza
- sulla base dei valori ottenuti fa dei controlli e in caso stampa a video l'attività che dovrebbe svolgere (per ora non abbiamo integrato al controller.py tutta la parte di gestione della scheda realais che abbiamo sui codici singoli presenti in Modelli, in quanto abbiamo voluto effettuare prima delle fasi di testing per controllare che il lavoro dei thread funzioni correttamente).
- se si entra in uno degli if (quindi verrebbe teoricamente acceso un attuatore) si eliminano tutti i valori all'interno della propria queue (in questo modo di fatto è come se si facesse un reset delle misurazioni).

Riportiamo ad esempio la funzione del DTH22, per il capacitive è simile, la si trova nel codice come def activity_Capacitive():
```python
## funzione attività del sensore DTH22, per misura umidità aria e temperatura
def activity_DHT22():
    global M_temperatura_aria
    global M_umidita_aria
    
#     lettura valori
    DHT = 21
    h,t = dht.read_retry(dht.DHT22, DHT)

    print('DHT22')
    #aggiorno la lista_valori_dht22_temperatura e la M_temperatura_aria
    M_temperatura_aria = update_M(lista_valori_dht22_temperatura, M_temperatura_aria, t)
    M_umidita_aria = update_M(lista_valori_dht22_umidita, M_umidita_aria, h)
    
#     controllo attività
#   le attività possono essere svolte solo se l'array dei valori è pieno
    if(lista_valori_dht22_umidita.full()):
#       Umidificazione
        if M_umidita_aria < Min_umidita_aria:
            activitycaso("umidificazione") 
            time.sleep(10)
#             azzeriamo le medie e svuotiamo gli array
            clearList(lista_valori_dht22_temperatura)
            clearList(lista_valori_dht22_umidita)
            M_temperatura_aria = 0
            M_umidita_aria = 0
#        Ventilazione Alta
        elif M_umidita_aria > Max_umidita_aria:
            activitycaso("ventilazione alta")
            time.sleep(10)
            #             azzeriamo le medie e svuotiamo gli array
            clearList(lista_valori_dht22_temperatura)
            clearList(lista_valori_dht22_umidita)
            clearList(lista_valori_capacitive)
            M_temperatura_aria = 0
            M_umidita_aria = 0
            M_umidita_suolo = 0
         
    print(list(lista_valori_dht22_umidita.queue))
    print("M: "+str(M_umidita_aria))
    print("--------------------")
    print(list(lista_valori_dht22_temperatura.queue))
    print("M: "+str(M_temperatura_aria))
    print("--------------------")
```

Per ultimo trattiamo lo scheduling dei thread.
In particolare il funzionamento del nostro sistema si basa su due thread che devono alternarsi nella lettura dei valori del sensore, di modo tale da non rischiare che solo uno dei due sensori venga letto mentre l'altro no.
Per fare ciò abbiamo quindi creato un mutex che i due thread condividono e che devono necessariamente possedere per poter leggere un valore del sensore a cui sono associati. Una volta letto il valore rilasciano il mutex.
Tuttavia, affinchè la lettura sia sempre alternata e che quindi la lettura dei due sensori avvenga di pari passo, abbiamo deciso di introdurre un controllo mediante una pila.
Questa serve per poter simulare la fila di attesa dei thread, andando a svolgere l'attività solamente del thread che si trova nella testa della pila; una volta eseguita il thread viene poi buttato fuori dalla pila, facendo scalare di posizione quelli dietro.
```python
#classe custom per gestire la queue dei thread che richiedono un lock condiviso
class pila:
    #la pila ha due campi
    #lista di thread che è un array chiamato Elementi
    #l'ultimo elemento che è stato buttato fuori dalla lista che all'inizio è 1 a caso
    def __init__(self):
        self.Elementi = []
        self.lastpop = 1

    #la push inserisce in fondo alla lista l'elemento
    def push(self, element):
        self.Elementi.append(element)

    #la pop aggiorna il nuovo ultimo elemento che viene buttato fuori e poi lo toglie
    def pop(self):
        self.lastpop = self.head()
        return self.Elementi.pop(0)

    #head permette di vedere chi si trova in cima alla lista
    def head(self):
        return self.Elementi[0]

    #stampa gli elementi della lista
    def print(self):
        for el in self.Elementi:
            print(el)

    #serve per vedere quante istanze di un element sono contenute all'interno della lista
    def search(self, element):
        return self.Elementi.count(element)

    #ritorna la lunghezza della lista
    def length(self):
        return len(self.Elementi)
```

Simuliamo il funzionamento del sistema con un thread t1 e t2.
t1 prende il lock, vede che la pila è vuota per cui entra nella fila di attesa. Successivamente si controlla se la testa della pila coincide con lui, se sì allora si esegue l'attività del thread, se no si lascia il lock e si attende, in quanto ci sono altri thread prima di lui.
Se t1 dovesse essere eseguito e quindi poi espulso dalla lista di attesa, se dovesse essere più veloce di t2, il rischio è che si possa eseguire due volte di fila t1 cosa che non vogliamo. Allora la pila tiene conto dell'ultimo thread che ha buttato fuori dalla sua testa, di modo tale che se dovesse essere ancora vuota e si dovesse ripresentare lo stesso thread, questo viene rifiutato, per non permettere che venga eseguito due volte di fila. t1 potrà entrare quindi di nuovo nella lista di attesa solamente se t2 verrà eseguito, permettendo quindi che i due thread si possano continuamente alternare.
```python
#variabili globali
mutex = RLock()
q = pila()

#classe Thread paralleli
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
