#le queue hanno un comportamento particolare, infatti è possibile andare a modificare una lista passandola solo come parametro a una funzione
#nonostante si facciano delle modifiche in locale, ovvero solo al parametro della funzione, queste modifiche vengono salvate anche per la variabile
#che è stata passata come parametro quando si è richiamata la funzione

#questa proprietà vale solo con liste non con variabili come x = numero

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


# metodo per rimuovere tutti gli elementi di una Queue
def clearList(lista):
    lista.queue.clear()
