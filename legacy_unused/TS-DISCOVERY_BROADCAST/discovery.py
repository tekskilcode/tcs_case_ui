import netifaces as ni
import socket
import time
import os

ip = '0.0.0.0'
ip2 = '0.0.0.0'

INSTALL_PATH = '/home/floormanager/fm_python/'

VERSION = "V:UNKNOWN | Tekskil Control Hub"

UDP_IP = "255.255.255.255"
UDP_PORT = 30303

MULTICAST_TTL = 2

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, MULTICAST_TTL)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
sock.bind(('0.0.0.0', 2860))

if os.path.exists(INSTALL_PATH + '/' + 'version.txt'):
    f = open(INSTALL_PATH + '/' + 'version.txt', "r")
    VERSION = "V:"+f.readline().strip()  + " | Tekskil Control Hub"
    f.close()
else:
    VERSION = "V:UNKNOWN | Tekskil Control Hub"

while(1==1):
    ni.ifaddresses('enp3s0')
    ip = ni.ifaddresses('enp3s0')[ni.AF_INET][0]['addr']
    #if(ip != ip2):
    hostname = socket.gethostname()
    mac_address = ni.ifaddresses('enp3s0')[ni.AF_LINK][0]['addr']
    MESSAGE = hostname + '\r\n' + mac_address + '\r\n' + VERSION 
    print(MESSAGE)
    MESSAGE = str.encode(MESSAGE)
    sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))
    #ip2 = ip
    time.sleep(2)
