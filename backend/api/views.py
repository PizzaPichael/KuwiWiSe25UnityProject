from django.contrib.auth.models import Group, User
from django.db.models import Count
from rest_framework import permissions, viewsets, generics, status
from rest_framework.response import Response
from rest_framework.views import APIView

from api.models import Airplane, Location, Type
from api.serializers import (
    AirplaneSerializer,
    AirplaneDetailSerializer,
    AirplaneLocationCountSerializer,
    GroupSerializer,
    LocationSerializer,
    TypeSerializer,
    UserSerializer,
)


class AiplaneViewSet(viewsets.ModelViewSet):
    queryset = Airplane.objects.all()  # required for router basename resolution
    serializer_class = AirplaneSerializer
    permission_classes = [permissions.AllowAny]
    lookup_field = "tail_number"  # allow lookup by tail number in router routes

    def get_queryset(self):
        # Prefetch locations so nested serialization is efficient
        return Airplane.objects.prefetch_related("location_set")

    def get_serializer_class(self):
        # Use detail serializer (with locations) on retrieve; basic serializer elsewhere
        if self.action == "retrieve":
            return AirplaneDetailSerializer
        return super().get_serializer_class()

class LocationViewSet(viewsets.ModelViewSet):
    queryset = Location.objects.all()
    serializer_class = LocationSerializer
    permission_classes = [permissions.AllowAny]

class AirplaneLocationCountView(generics.ListAPIView):
    serializer_class = AirplaneLocationCountSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        return (
            Airplane.objects.annotate(location_count=Count("location"))
            .order_by("-location_count", "tail_number")
        )

class AirplaneDetailView(generics.RetrieveAPIView):
    serializer_class = AirplaneDetailSerializer
    lookup_field = "tail_number"
    queryset = Airplane.objects.all()


class BulkTypeCreateView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        """
        Accepts either:
        - {"types": ["G280", "GLF2", ...]}
        - a comma-separated string: '"G280", "GLF2", ...'
        """
        raw_types = request.data.get("types", request.data)

        if isinstance(raw_types, str):
            parts = raw_types.split(",")
            type_strings = [p.strip().strip('"').strip("'") for p in parts if p.strip()]
        elif isinstance(raw_types, list):
            type_strings = [str(item).strip().strip('"').strip("'") for item in raw_types if str(item).strip()]
        else:
            return Response({"detail": "Provide a list of type codes or a comma-separated string."}, status=status.HTTP_400_BAD_REQUEST)

        # Deduplicate and enforce max length from the model
        cleaned = []
        seen = set()
        for code in type_strings:
            trimmed = code[:4].upper()
            if trimmed and trimmed not in seen:
                seen.add(trimmed)
                cleaned.append(trimmed)

        created = []
        existing = []
        for code in cleaned:
            obj, was_created = Type.objects.get_or_create(type=code)
            (created if was_created else existing).append(code)

        serializer = TypeSerializer(Type.objects.filter(type__in=cleaned), many=True)
        return Response(
            {"created": created, "existing": existing, "types": serializer.data},
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK,
        )
