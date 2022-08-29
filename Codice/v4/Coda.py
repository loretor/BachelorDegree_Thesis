#classe custom per gestire la queue dei thread che richiedono un lock condiviso
class coda:
    #la coda ha due campi
    #lista di thread che è un array chiamato Elementi
    #l'ultimo elemento della lista che è uscito tramite pop e inizialmente lo mettiamo a 1
    def __init__(self):
        self.Elementi = []
        self.lastpop = 1

    #la push inserisce in fondo alla lista l'elemento
    def push(self, element):
        self.Elementi.append(element)

    #la pop aggiorna il nuovo ultimo elemento che subisce il pop e poi lo toglie effettivamente dalla lista
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
