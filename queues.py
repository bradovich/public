class QueueError:  
    pass


class Queue:
    def __init__(self):
        self.__q = []

    def put(self, elem):
        self.__q.append(elem)

    def get(self):
        return self.__q[i]


que = Queue()
que.put(1)
que.put("dog")
que.put(False)
try:
    for i in range(4):
        print(que.get())
except:
    print("Queue error")
