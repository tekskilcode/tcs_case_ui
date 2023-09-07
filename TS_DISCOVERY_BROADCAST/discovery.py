import netifaces as ni
import socket
import time
import os

ip = '0.0.0.0'
ip2 = '0.0.0.0'

INSTALL_PATH = '/app/tcs_version'
WEB_UI_PATH = '/app/tkskl-server'

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
    VERSION = f.readline().strip() + " | "
    f.close()
else:
    VERSION = "V:NOVERSIONFILE | Tekskil Control Hub"

if os.path.exists(WEB_UI_PATH + '/' + 'version.txt'):
    f = open(WEB_UI_PATH + '/' + 'version.txt', "r")
    lines = []
    
    for line in f:
    	 lines.append(line.strip())
    
    web_versions = " | ".join(lines)
    VERSION = VERSION + web_versions 
    f.close()

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
