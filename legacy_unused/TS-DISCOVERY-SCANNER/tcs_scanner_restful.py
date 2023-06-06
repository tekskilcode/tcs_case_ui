import socket
import time
import json

UDP_IP = "0.0.0.0"
UDP_PORT = 30303

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

print("Listening for broadcast messages...")

detected_systems = []
scan_start = time.time()
scan_end = scan_start + 5 #seconds

while time.time() < scan_end:
    try:
        data, addr = sock.recvfrom(1024)
    except:
        data = b''	
    message = data.decode()
    message = message.rstrip('\r\n')
    message_parts = message.split('\r\n')
   
    if len(message_parts) == 3:
        hostname, mac_address, version = message_parts
        current_time = time.time()
        result = any(dict_item.get("ip") == addr[0] for dict_item in detected_systems)
        #if not duplicate, add to list
        if not result:
            detected_systems.append({"ip":addr[0], "host_name": hostname, "mac_address": mac_address, "version": version, "time": current_time})
            print(f"Detected system: {hostname} ({mac_address}), version {version}")
        else:
            print(f"Ignoring duplicate message from {addr[0]}")
    elif message:
        print(f"Received invalid message: {message}")

print(detected_systems)
