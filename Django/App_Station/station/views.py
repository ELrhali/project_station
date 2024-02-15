# views.py
from django.http import HttpResponse
from django.views import View
from django.shortcuts import render
import requests
from django.http import JsonResponse
from .models import Station
from rest_framework.views import APIView
from rest_framework.response import Response  # Add this line
from rest_framework import status
from .serializers import StationSerializer

from django.shortcuts import get_object_or_404





class StationList(APIView):
    serializer_class = StationSerializer

    def get(self, request, format=None):
        """
        Optionally filters the returned gazoles by 'station_id'
        """
 
        queryset = Station.objects.all()
        station_id = request.query_params.get('station_id', None)
        if station_id is not None:
            response = requests.get(f'http://192.168.1.162:8083/gazoles?station_id={station_id}')
            response2 = requests.get(f'http://192.168.1.162:8084/services?station_id={station_id}')
            print(response)
            arrstation = []
            for item in queryset:
                if(item.place_id == station_id):
                    station = {
                    'place_id': item.place_id,
                    'name': item.name,
                    'city': item.city,
                    'latitude': item.latitude,
                    'longitude': item.longitude,
                    # 'icon': item.icon,
                    'gazoles': response.json(),
                    'services': response2.json()
                    }
                    arrstation.append(station)
            
        return Response(arrstation[0])

class StationService(APIView):
    api_key = "AIzaSyAowkS7_XUjBOoEVxR71iK69o--gBkSHmg"
    api_url = "https://maps.googleapis.com/maps/api/place/textsearch/json"

    def get(self, request, city):
        url = f"{self.api_url}?query=diesel+fuel+stations+in+{city}&key={self.api_key}"

        # Make the API call and parse the response
        response = requests.get(url)
        json_response = response.json()

        # Parse the JSON response and prepare data
        stations = json_response.get("results", [])

        stations_data = []
        for station_node in stations:
            station = {
                'place_id': station_node.get("place_id"),
                'name': station_node.get("name"),
                'city': city,
                'latitude': None,
                'longitude': None,
                # 'icon': station_node.get("icon"),
            }

            # Set position if available
            geometry_node = station_node.get("geometry")
            if geometry_node:
                location_node = geometry_node.get("location")
                if location_node:
                    station['latitude'] = location_node.get("lat")
                    station['longitude'] = location_node.get("lng")

            stations_data.append(station)
            

            # Save data to the database using serializer
            serializer = StationSerializer(data=station)
            if serializer.is_valid():
                serializer.save()
        

        # Return the data as JSON response
        return Response("succ",status=status.HTTP_200_OK)
def show_stations(request):
    # Récupérer toutes les stations de la base de données
    stations = Station.objects.all()

    # Créer une liste pour stocker les données des stations
    stations_data = []

    for station in stations:
        station_data = {
            'place_id': station.place_id,
            'name': station.name,
            'city': station.city,
            'latitude': station.latitude,
            'longitude': station.longitude,
            # 'icon': station.icon,
        }
        stations_data.append(station_data)

    # Retourner les données au format JSON
    return JsonResponse({'stations': stations_data}, safe=False)





class StationListByCity(APIView):
    serializer_class = StationSerializer

    def get(self, request, city, format=None):
        # Vérifier si des stations existent déjà pour la ville donnée
        existing_stations = Station.objects.filter(city=city)

        if existing_stations.exists():
            # Si des stations existent, les récupérer et les afficher
            stations_data = self.serialize_stations(existing_stations)
            return Response({'stations': stations_data})

        else:
            # Si aucune station n'existe, créer les stations à partir de l'API Google Places
            stations_data = self.create_stations_from_api(city)
            return Response({'stations': stations_data})

    def serialize_stations(self, stations):
        # Convertir les objets Station en format JSON
        stations_data = []
        for station in stations:
            station_data = {
                'place_id': station.place_id,
                'name': station.name,
                'city': station.city,
                'latitude': station.latitude,
                'longitude': station.longitude,
                # 'icon': station.icon,
            }
            stations_data.append(station_data)
        return stations_data

    def create_stations_from_api(self, city):
        # Appeler la fonction existante pour récupérer les stations de l'API Google Places
        response = self.get_google_places_data(city)

        # Enregistrer les nouvelles stations dans la base de données
        new_stations_data = self.save_stations_to_database(response, city)

        return new_stations_data

    def get_google_places_data(self, city):
        # Appeler la fonction existante pour récupérer les données de l'API Google Places
        url = f"{StationService.api_url}?query=diesel+fuel+stations+in+{city}&key={StationService.api_key}"
        response = requests.get(url)
        return response.json().get("results", [])

    def save_stations_to_database(self, stations_data, city):
        # Enregistrer les nouvelles stations dans la base de données et les récupérer
        new_stations_data = []

        for station_node in stations_data:
            station = {
                'place_id': station_node.get("place_id"),
                'name': station_node.get("name"),
                'city': city,
                'latitude': None,
                'longitude': None,
                # 'icon': station_node.get("icon"),
            }

            # Set position if available
            geometry_node = station_node.get("geometry")
            if geometry_node:
                location_node = geometry_node.get("location")
                if location_node:
                    station['latitude'] = location_node.get("lat")
                    station['longitude'] = location_node.get("lng")

            # Enregistrer la nouvelle station dans la base de données
            serializer = StationSerializer(data=station)
            if serializer.is_valid():
                serializer.save()
                new_stations_data.append(station)

        return new_stations_data