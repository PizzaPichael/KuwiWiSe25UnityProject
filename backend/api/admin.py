from django.contrib import admin

from api.models import Airplane, Location, Type

class AirplaneInline(admin.TabularInline):
    model = Location
    extra = 0

@admin.register(Airplane)
class AiplaneAdmin(admin.ModelAdmin):
    list_display = ("tail_number", "type")
    inlines = [AirplaneInline]

@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display = ("time", "latitude", "longitude", "ground_speed", "track", "altitude")

@admin.register(Type)
class TypeAdmin(admin.ModelAdmin):
    list_display = ("type",)