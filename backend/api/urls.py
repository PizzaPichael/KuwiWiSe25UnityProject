from django.urls import path
from api.views import AirplaneDetailView, AirplaneLocationCountView, BulkTypeCreateView

urlpatterns = [
    path("airplanes/location-count/", AirplaneLocationCountView.as_view(), name="airplane-location-count"),
    path("airplanes/<str:tail_number>/", AirplaneDetailView.as_view(), name="airplane-detail"),
    path("types/bulk/", BulkTypeCreateView.as_view(), name="type-bulk-create"),
]
