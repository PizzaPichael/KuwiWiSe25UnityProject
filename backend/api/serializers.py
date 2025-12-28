from django.contrib.auth.models import Group, User
from rest_framework import serializers

from api.models import Airplane, Location, Type


class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ["url", "username", "email", "groups"]


class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Group
        fields = ["url", "name"]


class AirplaneSerializer(serializers.ModelSerializer):
    class Meta:
        model = Airplane
        fields = ["tail_number", "type_description", "type"]


class LocationSerializer(serializers.ModelSerializer):
    airplane = serializers.SlugRelatedField(
        slug_field="tail_number", read_only=True
    )

    class Meta:
        model = Location
        fields = ["time", "airplane", "latitude", "longitude", "ground_speed", "track", "altitude"]


class AirplaneDetailSerializer(serializers.ModelSerializer):
    locations = LocationSerializer(source="location_set", many=True, read_only=True)

    class Meta:
        model = Airplane
        fields = ("tail_number", "type", "type_description", "locations")


class AirplaneLocationCountSerializer(serializers.ModelSerializer):
    location_count = serializers.IntegerField(read_only=True)

    class Meta:
        model = Airplane
        fields = ("tail_number", "type", "location_count")


class TypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Type
        fields = ("type",)
