# station/urls.py
from django.urls import path
from .views import StationList, StationListByCity, StationService, show_stations

urlpatterns = [
    path('', show_stations, name='show_stations'),
    path('reach/<str:city>/', StationService.as_view(), name='station-service'),
    path('stations_list', StationList.as_view(), name='station-list'),
    path('stations/<str:city>/', StationListByCity.as_view(), name='station-list-by-city'),

]
