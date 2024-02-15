from rest_framework import viewsets, status
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Service
from .serializers import ServiceSerializer

class ServiceViewSet(viewsets.ModelViewSet):
    queryset = Service.objects.all()
    serializer_class = ServiceSerializer

class ServiceList(APIView):
    serializer_class = ServiceSerializer

    def get(self, request, format=None):
        """
        Optionally filters the returned Services by 'station_id' and 'typeService'
        """
        station_id = request.query_params.get('station_id', None)
        type_service = request.query_params.get('typeService', None)

        queryset = Service.objects.all()

        if station_id is not None:
            queryset = queryset.filter(station_id=station_id)

        if type_service is not None:
            queryset = queryset.filter(typeService__iexact=type_service)

        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)