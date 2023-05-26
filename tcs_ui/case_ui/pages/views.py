import io
import netifaces as ni
import requests
import json
import ping3
import psutil

from django.shortcuts import render
from django.http import JsonResponse


# Create your views here.
def home(request):
	if len(ni.ifaddresses('enp3s0'))>1 :
		data = {'theNum': str(ni.ifaddresses('enp3s0')[ni.AF_INET][0]['addr'])}
		data["hasNetwork"] = True
	else:
		data = {'theNum': "No Connection"}
		data["hasNetwork"] = False
	
	data["hasInternet"] = is_connected()
	# data["DHCP"] = is_dhcp_enabled('enp3s0')
	#str(ip)}
	return render(request, 'pages/home.html', data)

def sleep(request):
	return render(request, 'pages/sleep.html')

def connect(request):
	# filename = "/app/data/detected_systems.txt"
	# with open(filename, "w+") as file:
	# 	file_contents = file.read()
	# 	file.close()
	# 	print("file ocntens")
	# 	print(file_contents)
	# if file_contents:
	# 	print(file_contents)
	# 	loaded_data = json.loads(str(file_contents))
	# 	data = {"systems":loaded_data}
	# 	# data = {"systems":[{"ip":"", "host_name": "No poops Found", "mac_address": "", "version": "", "time": ""}]}
	# else:
	# 	data= {"systems":[{"ip":"8.8.8.8", "host_name": "No Systems Found", "mac_address": "", "version": "", "time": ""}]}
	
	return render(request, 'pages/connect.html')

def custom_ip(request):
	data = {"test":"testx"}
	return render(request, 'pages/custom_ip.html', data)

def check(request):
	if request.method == 'GET':
		print(request.GET)
		ip_address = request.GET.get('ip_address')
		# Process the IP address as needed
		pingTime = ping_ip_address(str(ip_address))*1000
		return JsonResponse({'message': round(pingTime,2)})
	else:
		return JsonResponse({'message': 'Invalid request method'})


def is_connected():
	try:
		# try to make a request to Google's homepage
		response = requests.get('https://www.google.com/')
		return True
	except requests.exceptions.ConnectionError:
		pass
	return False

def ping_ip_address(ip_address):
    response_time = ping3.ping(ip_address)
    if response_time is not None:
        return response_time
    else:
        return False

def is_dhcp_enabled(interface_name):
    for addr in psutil.net_if_addrs()[interface_name]:
        if addr.family == psutil.AF_INET and addr.address.startswith('169.254'):
            return True
    return False


	