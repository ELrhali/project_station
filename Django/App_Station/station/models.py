from django.db import models

class Station(models.Model):
    place_id = models.CharField(max_length=255, primary_key=True)
    name = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    # icon = models.CharField(max_length=255)

    def set_geometry(self, geometry_node):
        location_node = geometry_node.get("location")
        if location_node:
            self.latitude = location_node.get("lat")
            self.longitude = location_node.get("lng")

    def set_icon(self, icon):
        self.icon = icon