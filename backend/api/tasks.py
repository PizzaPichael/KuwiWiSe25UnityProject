from celery import shared_task
from api.models import Airplane, Location, Type
from django.db import IntegrityError, transaction


@shared_task
def fetch_data():
    """Fetch airplanes by type and record their latest positions."""
    import time
    from datetime import datetime, timezone

    import requests

    aircraft_types = list(Type.objects.values_list("type", flat=True))
    print(f"aircraft types: {aircraft_types}")

    for aircraft_type in aircraft_types:
        print(f"fetching data for type: {aircraft_type}")
        time.sleep(1)  # avoid hammering the API
        response = requests.get(f"https://api.airplanes.live/v2/type/{aircraft_type}")
        if response.status_code != 200:
            continue

        data = response.json() or {}
        for plane in data.get("ac", []):
            tail_number = (plane.get("r") or "").strip().upper()
            type_description = plane.get("desc") or "NA"
            lat = plane.get("lat")
            lon = plane.get("lon")
            plane_type = plane.get("t") or aircraft_type
            ground_speed = plane.get("gs") or -1
            track = plane.get("track") or -1
            altitude = plane.get("alt_baro") or -1
            if altitude == "ground":
                altitude = -1

            if not tail_number or lat is None or lon is None:
                continue

            if len(tail_number) > 10:
                continue

            observed_time = datetime.now(timezone.utc)

            try:
                with transaction.atomic():
                    airplane, created = Airplane.objects.get_or_create(
                        tail_number=tail_number,
                        type_description=type_description,
                        defaults={"type": plane_type},
                    )
                    if not created and plane_type and airplane.type != plane_type:
                        airplane.type = plane_type
                        airplane.save(update_fields=["type"])
            except IntegrityError:
                airplane = Airplane.objects.get(tail_number=tail_number)
                if plane_type and airplane.type != plane_type:
                    airplane.type = plane_type
                    airplane.save(update_fields=["type"])

            Location.objects.create(
                latitude=lat,
                longitude=lon,
                time=observed_time,
                airplane=airplane,
                ground_speed=ground_speed,
                track=track,
                altitude=altitude
            )
