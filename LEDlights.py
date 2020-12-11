# this program prints any non-interger input into LED lights
# define lists of tuples that indicate where to print hashes on each line for each number the user inputs

p0 = [(1,2,3),(1,3),(1,3),(1,3),(1,2,3)]
p1 = [(3),(3),(3),(3),(3)]
p2 = [(1,2,3),(3),(1,2,3),(1),(1,2,3)]
p3 = [(1,2,3),(3),(1,2,3),(3),(1,2,3)]
p4 = [(1,3),(1,3),(1,2,3),(3),(3)]
p5 = [(1,2,3),(1),(1,2,3),(3),(1,2,3)]
p6 = [(1,2,3),(1),(1,2,3),(1,3),(1,2,3)]
p7 = [(1,2,3),(3),(3),(3),(3)]
p8 = [(1,2,3),(1,3),(1,2,3),(1,3),(1,2,3)]
p9 = [(1,2,3),(1,3),(1,2,3),(3),(1,2,3)]
lightlist = [p0,p1,p2,p3,p4,p5,p6,p7,p8,p9]

# user input
usernum = int(input("Enter a non-negative integer number: "))

# traps user if they input a non-negative number until they obey
while usernum < 0:
    usernum = int(input("Enter a non-negative integer number: "))

# function to count how many digits number has
def countDigit(usernum):
    count = 0
    while usernum != 0:
        usernum //= 10
        count += 1
    return count

digits = countDigit(usernum)

# create list containing each digit
listnum=[]

for i in range(digits):
    addnum = usernum % 10
    listnum.append(addnum)
    usernum //= 10

listnum = listnum[::-1]
# print(listnum) # prints user's number in list form

ledlist = []
# convert corresponding digits to lightlist matrices defined for 0-9
for dig in listnum:
    ledlist.append(lightlist[dig])

# print(ledlist) # full instructions

# transpose matrix
lineinst=[[ledlist[j][i] for j in range(len(ledlist))] for i in range(len(ledlist[0]))]

# print hashes
for row in lineinst:
    for i in row:
        if i == 3:
            print("  #",end=" ")
        elif i == 1:
            print("#  ",end=" ")
        elif i == (1, 3):
            print("# #",end=" ")
        elif i == (1, 2, 3):
            print("###",end=" ")
    print()
