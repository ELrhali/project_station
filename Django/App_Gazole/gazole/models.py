from django.db import models

class GazolePrice(models.Model):
    dissel = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    station_id = models.CharField(max_length=255, blank=False, null=False)
    date_added = models.DateTimeField(auto_now_add=True)
    date_updated = models.DateTimeField(auto_now=True)
    premium = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    essance = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)

    def __str__(self):
        return f"{self.station_id} - Diesel: {self.dissel}, Premium: {self.premium}, Essence: {self.essance}"

# class GazoleType(enum.Enum):
#     DIESEL = "Diesel"
#     PREMIUM_DIESEL = "Premium Diesel" 
#     ESSANCE = "Essance"

#     def __str__(self):
#         return self.value

# class Gazole(models.Model):
#     type = models.CharField(
#         max_length=255,
#         choices=[(tag.name, tag.value) for tag in GazoleType],
#         default=GazoleType.DIESEL
#     )
#     station_id = models.CharField(max_length=255, blank=False, null=False)

#     def __str__(self):
#         return f"{self.type} - {self.price}"



# class GazoleStatus(models.Model):
    
#     gazole = models.ForeignKey(Gazole, on_delete=models.CASCADE)
#     price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
#     date_added = models.DateTimeField(auto_now_add=True)
#     date_updated = models.DateTimeField(auto_now=True)

#     def __str__(self):
#         return f"{self.type} - {self.price}"

