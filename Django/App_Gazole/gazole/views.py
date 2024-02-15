from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import GazolePrice
from .serializers import GazolePriceSerializer

class GazoleViewSet(viewsets.ModelViewSet):
    queryset = GazolePrice.objects.all()
    serializer_class = GazolePriceSerializer


# class GazoleStatusViewSet(viewsets.ModelViewSet):
#     queryset = GazoleStatus.objects.all()
#     serializer_class = GazoleStatusSerializer


class GazoleList(APIView):
    serializer_class = GazolePriceSerializer

    def get(self, request, format=None):
        """
        Optionally filters the returned gazoles by 'station_id'
        """
        # queryset = Gazole.objects.all().prefetch_related('gazolestatus_set')
        queryset = GazolePrice.objects.all()
        station_id = request.query_params.get('station_id', None)
        if station_id is not None:
            queryset = queryset.filter(station_id=station_id)
        serializer = self.serializer_class(queryset, many=True)
        return Response(serializer.data)