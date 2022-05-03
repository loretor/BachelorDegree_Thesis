from threading import Thread, RLock
import time

mutex = RLock()
last = None

class Player(Thread):
    def __init__(self, sound):
        Thread.__init__(self)
        self.sound = sound
        
    def run(self):
        global mutex
        global last

        while True:
            mutex.acquire()
            if(last != self.sound):
                last = self.sound
                print(self.sound)       
            mutex.release()

t1 = Player("ping")
t2 = Player("pong")
t1.start()
t2.start()
mutex.release()
t1.join()
t2.join()