import socket
import time
import json

UDP_IP = "0.0.0.0"
UDP_PORT = 30303

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

print("Listening for broadcast messages...")

detected_systems = []

while True:
    try:
        data, addr = sock.recvfrom(1024)
    except:
        data = b''
    message = data.decode()
    message_parts = message.split('\r\n')
    if len(message_parts) == 3:
        hostname, mac_address, version = message_parts
        current_time = time.time()
        result = any(dict_item.get("host_name") == hostname for dict_item in detected_systems)
        
        if not result:
            detected_systems.append({"ip":addr[0], "host_name": hostname, "mac_address": mac_address, "version": version, "time": current_time})
            print(f"Detected system: {hostname} ({mac_address}), version {version}")
        else:
            print(f"Ignoring duplicate message from {hostname}")
    elif message:
        print(f"Received invalid message: {message}")
    # current_time = time.time()
    # for system in list(detected_systems):
    #     if current_time - detected_systems[system]["time"] > 10:
    #         del detected_systems[system]
    #         print(f"Removed system {system} from list of detected systems.")
    
    with open("/app/data/detected_systems.txt", "w+") as file:
        print("saving file");
        json.dump(detected_systems, file)


    time.sleep(2)
