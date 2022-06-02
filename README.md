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
Queste due attività sono state implementate con dei thread che condividono un lock per la risorsa condivisa. L'idea è infatti quella di alternare la lettura prima di un sensore (thread1) e poi quella del secondo sensore (thread2), di modo tale che poi sempre nel momento in cui ogni thread possiede il lock possa eventualmente azionare degli attuatori qualora sulla base della propria lettura sia necessario intervenire sulla serra (esempio: DHT22 legge una nuova temperatura, calcola la media delle ultime temperature lette e osserva che la temperatura media è troppo alta per la serra, per cui chiude il circuito della scheda relais e attiva la ventola per poter permettere un recircolo d'aria; una volta terminato rilascia il lock per permettere al Capacitive di proseguire con la sua lettura).

