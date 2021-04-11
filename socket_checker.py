import sys
import socket

# simple client program to check web address/IP connectivity (0 if yes, 1 if no)

def AddCheck(addy, prt=80):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((addy, prt))
            return 0
    except:
        return 1

if len(sys.argv) not in [2, 3]:
    a = input("Enter an IP address or domain name: ")

AddCheck(a)
