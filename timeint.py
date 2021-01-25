class TimeInt:
    
    def __init__(self,h,m,s):
        self.s = 60*60*int(h) + 60*int(m) + int(s)
        
    def __str__(self,t):
        h = t//(60**2)
        m = (t - h*(60**2))//60
        s = t - 60*m - h*(60**2)
        lis = []
        for i in [h,m,s]:
            if len(str(i)) == 2:
                lis.append(str(i))
            elif len(str(i)) == 1:
                lis.append('0'+str(i))
                
        return ":".join(lis)
        
    def __add__(self,inter):
        m = inter.s + self.s
        return self.__str__(m)
        
    def __sub__(self,inter): 
        m = abs(inter.s - self.s)
        return self.__str__(m)
        
    def __mul__(self,n):
        m = n*self.s
        return self.__str__(m)
        
        
ti1 = TimeInt(21,58,50)
ti2 = TimeInt(1,45,22)
print(ti1 + ti2)
print(ti1 - ti2)
print(ti1*2)
