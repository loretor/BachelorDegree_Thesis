from threading import Thread, RLock
import time, queue

class pila:
    def __init__(self):
        self.Elementi = []
        
    def push(self, Elemento):
        self.Elementi.append(Elemento)
    
    def pop(self):
        return self.Elementi.pop()
    
    def head(self):
        return self.Elementi[0]
        
    
mutex = RLock()
q = pila()

class Player(Thread):
    def __init__(self, sound):
        Thread.__init__(self)
        self.sound = sound
        
    def run(self):
        global mutex
        global q

        while True:
            q.push(self.sound)
            mutex.acquire()
            
            if(q.head() == self.sound):
                print(q.head())  
                q.pop()
            else:
                q.remove(self.sound)
            mutex.release()

t1 = Player("ping")
t2 = Player("pong")
t1.start()
t2.start()

t1.join()
t2.join()
