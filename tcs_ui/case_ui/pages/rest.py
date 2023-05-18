import io
import netifaces as ni
import requests
import json
import ping3
import psutil
import subprocess
import os
import time

from django.shortcuts import render
from django.http import JsonResponse


def check(request):
	if request.method == 'GET':
		ip_address = request.GET.get('ip_address')
		# Process the IP address as needed
		pingTime = ping_ip_address(str(ip_address))*1000
		return JsonResponse({'message': round(pingTime,2)})
	else:
		return JsonResponse({'message': 'Invalid request method'})


def cust_ip(request):
	if request.method == 'GET':
		testvar = ""
		pipe_path = './compipe/compipe'
		pipe_fd = os.open(pipe_path, os.O_WRONLY)
		print('pipe connected')
		if request.GET.get('req_dhcp') == 'true':
			print('new dhcp please')
			#request dhcp
			message = 'dhclient -r enp3s0 \n'
			os.write(pipe_fd, message.encode())
			#time.sleep(1)
			message2 = 'dhclient enp3s0 \n'
			os.write(pipe_fd, message2.encode())
			# message3 = 'dhclient \n'
			# os.write(pipe_fd, message2.encode())
			time.sleep(5)
		else:
			new_ip =request.GET.get('new_ip')
			
			print("ipabove subnet below")
			new_subnet = str(request.GET.get('new_subnet'))
			print(new_subnet)
			# Convert subnet mask to a list of binary octets
			binary_octets = [bin(int(octet))[2:].zfill(8) for octet in new_subnet.split(".")]
			# Count the number of '1's in the binary representation
			prefix_length = sum(bit == '1' for octet in binary_octets for bit in octet)
			new_subnet_prefix = prefix_length
			print(prefix_length)  # Output: 24
			new_gateway = request.GET.get('new_gateway')
			print(new_gateway)
			#command = 'nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.0.179/24 ipv4.gateway 192.168.0.1 ipv4.method manual ipv4.dns 192.168.0.1 > ./compipe/compipe'
			message = 'nmcli connection modify "Wired connection 1" ipv4.addresses '+str(new_ip)+'/'+str(prefix_length)+' ipv4.gateway '+str(new_gateway)+' ipv4.method manual ipv4.dns '+str(new_gateway)+' \n'
			os.write(pipe_fd, message.encode())
			print("ip changedx")
			message2 = 'nmcli connection down "Wired connection 1" \n'
			os.write(pipe_fd, message2.encode())
			print("connection down")
			message3 = 'nmcli connection up "Wired connection 1" \n'
			os.write(pipe_fd, message3.encode())
			print("connection up")
			#nmcli connection show
		return JsonResponse({'message': 'request run'})
	
	

def power(request):
	if request.method == 'GET':
		pipe_path = './compipe/compipe'
		pipe_fd = os.open(pipe_path, os.O_WRONLY)
		
		if request.GET.get('type') == "reboot":
			message = 'reboot \n'
			os.write(pipe_fd, message.encode())
			return JsonResponse({'message': 'reboot init'})

		if request.GET.get('type') == "shutdown":
			message = 'shutdown -h now \n'
			os.write(pipe_fd, message.encode())
			return JsonResponse({'message': 'shutdown init'})