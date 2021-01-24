from random import uniform

class Apple:
    ct = 0
    tw = 0
    def __init__(self):
        # random weight of apple between 0.2 and 0.5 pounds
        self.wght = uniform(0.2,0.5)
        Apple.tw += self.wght

# customer requests order of apples
# order cannot exceed 1000 apples or 300 pounds
order = []
for i in range(1000):
    while Apple.tw <= 300:
        tempapp = Apple()
        order.append(tempapp)
        Apple.ct += 1

print("Number of apples:",Apple.ct)
print("Order weight:",Apple.tw)
