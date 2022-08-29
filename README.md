# Progetto di Tesi con Raspberry 👨‍💻
Creazione di una serra automatica con la scheda Raspberry

# 🧑‍💻 Componenti del gruppo di lavoro
- Matteo Carminati
- Lorenzo Torri

# 📂 Organizzazione della repository
Nella cartella [Modelli](/Modelli) sono presenti le rappresentazioni UML del progetto. Per ora l'unica rappresentazione creata è quella di uno StateChart Diagram.

Nella cartella [Codice](/Codice) sono presenti tutti i file .py creati per controllare sensori e attuatori tramite Raspberry. In particolare sono presenti i file python che sono stati usati per controllare singolarmente i sensori e per chiudere ed aprire il circuito che collega rasperry alla scheda relais.

Nella cartella [Codice/v4](/Codice/v4) è presente tutto il codice necessario per controllare raspberry, con una suddivisione in vari moduli per poter organizzare meglio tutto il codice.

Il file [controller.py](/Codice/v4/Controller.py) è il cuore del controlloro di raspberry per poter permettere alla scheda di svolgere più attività e controllare lo scheduling di queste ultime.

Nella cartella [Codice/AWS](/Codice/AWS) sono presenti i due file Python necessari per il controllo delle funzioni lambda dell'architettura Cloud.

Il folder (/Codice/AWS) presenta un'insieme di file generati da Flutter per poter eseguire l'applicazione Mobile. In particolare nella cartella [AppMobile/serra_app/lib] (/AppMobile/serra_app/lib)sono presenti i file .dart sviluppati per la parte grafica



