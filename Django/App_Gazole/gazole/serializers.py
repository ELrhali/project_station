from rest_framework import serializers
from .models import  GazolePrice

# class GazoleStatusSerializer(serializers.ModelSerializer):

#     class Meta:
#         model = GazoleStatus
#         fields = ('id', 'price', 'date_added', 'date_updated')

# class GazoleSerializer(serializers.ModelSerializer):
#     gazole_status = GazoleStatusSerializer(many=True, read_only=True, source='gazolestatus_set')

#     class Meta:
#         model = Gazole
#         fields = ('id', 'type', 'station_id', 'gazole_status')

class GazolePriceSerializer(serializers.ModelSerializer):
    class Meta:
        model = GazolePrice
        fields = '__all__'
