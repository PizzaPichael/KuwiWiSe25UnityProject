from django.db import models

# Create your models here.
class Airplane(models.Model):
    type: str = models.CharField(max_length=4)
    tail_number: str = models.CharField(max_length=100, unique=True)
    type_description = models.CharField(max_length=256, default="NA")
    class Meta:
        ordering = ["tail_number"]
        verbose_name_plural = "Airplanes"
    def __str__(self):
        return self.tail_number

class Location(models.Model):
    latitude: float = models.DecimalField(max_digits=14, decimal_places=6)
    longitude: float = models.DecimalField(max_digits=15, decimal_places=6)
    time = models.DateTimeField()
    ground_speed = models.FloatField(default=-1)
    track = models.FloatField(default=-1)
    altitude = models.FloatField(default=-1)
    airplane = models.ForeignKey(Airplane, on_delete=models.CASCADE)
    class Meta:
        ordering = ["time"]
        verbose_name_plural = "Locations"
    
    def __str__(self):
        return str(self.time)

class Type(models.Model):
    type: str = models.CharField(max_length=4, unique=True)
    class Meta:
        ordering = ["type"]
        verbose_name_plural = "types"
    def __str__(self):
        return self.type
