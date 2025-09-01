import io
import netifaces as ni
import requests
import json
import ping3
import psutil
import os

from django.shortcuts import render
from django.http import JsonResponse

from case_ui.allowed_hosts import HOSTS


def get_active_network_interface():
    """
    Get the active network interface with an IP address (not loopback).
    Returns the interface name and IP address.
    """
    interfaces = ni.interfaces()
    
    for interface in interfaces:
        # Skip loopback interfaces
        if interface.startswith('lo'):
            continue
            
        try:
            addresses = ni.ifaddresses(interface)
            
            # Check if interface has IPv4 address
            if ni.AF_INET in addresses:
                ip_info = addresses[ni.AF_INET][0]
                ip_addr = ip_info['addr']
                
                # Skip localhost/loopback addresses and link-local addresses
                if not ip_addr.startswith('127.') and not ip_addr.startswith('169.254.'):
                    return interface, ip_addr
        except (KeyError, IndexError, ValueError):
            # Skip interfaces that don't have proper address info
            continue
    
    return None, None


def get_primary_network_interface():
    """
    Alternative method using psutil to get the primary network interface.
    This tries to find the interface used for the default route.
    """
    try:
        # Get network interfaces with statistics
        net_io = psutil.net_io_counters(pernic=True)
        net_addrs = psutil.net_if_addrs()
        
        # Find interface with most bytes sent/received (likely the active one)
        active_interface = None
        max_traffic = 0
        
        for interface, stats in net_io.items():
            # Skip loopback
            if interface.startswith('lo'):
                continue
                
            total_traffic = stats.bytes_sent + stats.bytes_recv
            
            # Check if interface has IP address
            if interface in net_addrs:
                for addr in net_addrs[interface]:
                    if addr.family == 2:  # IPv4
                        ip_addr = addr.address
                        # Skip localhost and link-local
                        if not ip_addr.startswith('127.') and not ip_addr.startswith('169.254.'):
                            if total_traffic > max_traffic:
                                max_traffic = total_traffic
                                active_interface = interface
                                
        if active_interface:
            # Get the IP address for the active interface
            for addr in net_addrs[active_interface]:
                if addr.family == 2:  # IPv4
                    ip_addr = addr.address
                    if not ip_addr.startswith('127.') and not ip_addr.startswith('169.254.'):
                        return active_interface, ip_addr
                        
    except Exception as e:
        print(f"Error getting primary interface: {e}")
        
    return None, None


# Create your views here.
def home(request):
    # Try to get active network interface
    interface_name, ip_address = get_active_network_interface()
    
    # If the first method didn't work, try the alternative method
    if not interface_name:
        interface_name, ip_address = get_primary_network_interface()
    
    if interface_name and ip_address:
        data = {'theNum': ip_address}
        data["hasNetwork"] = True
        data["interface"] = interface_name  # Optional: include interface name for debugging
        
        # Add IP to allowed hosts if not already present
        if ip_address not in HOSTS:
            HOSTS.append(ip_address)
    else:
        data = {'theNum': "No Connection"}
        data["hasNetwork"] = False
        data["interface"] = "None"
    
    data["hasInternet"] = is_connected()
    data["versions"] = get_sys_info()

    return render(request, 'pages/home.html', data)


def sleep(request):
    return render(request, 'pages/sleep.html')


def connect(request):
    return render(request, 'pages/connect.html')


def custom_ip(request):
    data = {"test":"testx"}
    return render(request, 'pages/custom_ip.html', data)


def check(request):
    if request.method == 'GET':
        print(request.GET)
        ip_address = request.GET.get('ip_address')
        # Process the IP address as needed
        pingTime = ping_ip_address(str(ip_address))
        if pingTime:
            return JsonResponse({'message': round(pingTime * 1000, 2)})
        else:
            return JsonResponse({'message': 'Host unreachable'})
    else:
        return JsonResponse({'message': 'Invalid request method'})


def get_sys_info():
    INSTALL_PATH = '/app/tcs_version'
    WEB_UI_PATH = '/app/tkskl-server'
    versions = []

    if os.path.exists(INSTALL_PATH + '/' + 'version.txt'):
        with open(INSTALL_PATH + '/' + 'version.txt', "r") as f:
            versions.append(f.readline().strip())

    if os.path.exists(WEB_UI_PATH + '/' + 'version.txt'):
        with open(WEB_UI_PATH + '/' + 'version.txt', "r") as f:
            for line in f:
                versions.append(line.strip())

    return versions


def is_connected():
    try:
        # try to make a request to Google's homepage
        response = requests.get('https://www.google.com/', timeout=5)
        return True
    except requests.exceptions.ConnectionError:
        pass
    except requests.exceptions.Timeout:
        pass
    return False


def ping_ip_address(ip_address):
    response_time = ping3.ping(ip_address)
    if response_time is not None:
        return response_time
    else:
        return False


def is_dhcp_enabled(interface_name):
    """
    Check if DHCP is enabled on the given interface.
    Link-local addresses (169.254.x.x) typically indicate DHCP failure.
    """
    try:
        for addr in psutil.net_if_addrs()[interface_name]:
            if addr.family == psutil.AF_INET and addr.address.startswith('169.254'):
                return False  # DHCP likely failed, got link-local address
        return True  # Assume DHCP is working if we have a proper IP
    except KeyError:
        return False


def get_all_network_interfaces():
    """
    Utility function to get all network interfaces with their IP addresses.
    Useful for debugging or showing available interfaces.
    """
    interfaces_info = {}
    
    for interface in ni.interfaces():
        try:
            addresses = ni.ifaddresses(interface)
            if ni.AF_INET in addresses:
                ip_info = addresses[ni.AF_INET][0]
                interfaces_info[interface] = {
                    'ip': ip_info['addr'],
                    'netmask': ip_info.get('netmask', ''),
                    'broadcast': ip_info.get('broadcast', '')
                }
        except (KeyError, IndexError):
            pass
            
    return interfaces_info