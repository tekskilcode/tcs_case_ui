from django.urls import path
from . import views
from . import rest

urlpatterns = [
    path('', views.home, name='home'),
    path('sleep/', views.sleep, name='sleep'),
    path('connect/', views.connect, name='connect'),
    path('custom_ip/', views.custom_ip, name='custom_ip'),
    path('check/', views.check, name='check'), 
    path('cust_ip/', rest.cust_ip, name='cust_ip'),
    path('power/', rest.power, name='power')
]
