from django.db import models
import enum

class ServiceType(enum.Enum):
    Playground = "Playground"
    Restaurant= "Restaurant"
    Washing = "Washing"

    def __str__(self):
        return self.value



class Service(models.Model):
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    station_id = models.CharField(max_length=255, blank=False, null=False)  # Change to CharField
    description = models.TextField(max_length=500, blank=False, null=False)
    name = models.CharField(max_length=255)

    
    typeService = models.CharField(
        max_length=255,
        choices=[(tag.name, tag.value) for tag in ServiceType],
        default=ServiceType.Restaurant
    )



    def __str__(self):
        return f"{self.name} - {self.price}"
