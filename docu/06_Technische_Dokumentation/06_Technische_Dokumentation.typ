= Technische Dokumentation

== Architektur
- Backend: Django 5.2 + DRF + Celery. Datenmodell: `Type` (Aircraft-Code), `Airplane` (Tail-Number, Typ, Beschreibung), `Location` (Lat/Lon/Zeit/Speed/Track/Altitude, FK auf Airplane).
- Datenquelle: `api.tasks.fetch_data` ruft alle 5 Minuten https://api.airplanes.live/v2/type/<type> ab, upsertet Flugzeuge und erstellt Locations mit aktuellem Zeitstempel; einfache Rate-Limit-Schonung über `sleep(1)`.
- API: `/api/airplanes/` (CRUD), Detail per Tail-Number, `/api/airplanes/location-count/` (Ranking), `/api/locations/`, `/api/types/bulk/` (List oder CSV). Swagger/Redoc verfügbar.
- Infrastruktur: Docker Compose startet Web (gunicorn), Worker, Beat, RabbitMQ, Postgres. Fallback auf SQLite lokal. Whitenoise liefert Static Files.

== Unity-Datenfluss
1. `AirplaneMapper` startet im AR-Scene-Setup und lädt per `CoordinateFetcher` wahlweise populäre Flugzeuge oder eine Liste aus dem Inspector.
2. `CoordinateFetcher` konsumiert die Django-API und liefert JSON-Responses für Tail-Number oder Popular-Endpunkt.
3. `ListCoordinateMapper` wandelt jede Location in Weltkoordinaten auf dem Globus um (Lat/Lon → 3D-Richtung, Altitude -> radialer Offset, sortiert nach Timestamp).
4. Für jedes Flugzeug wird ein Prefab instanziiert (`Airplane`-Komponente). `Airplane.Initialize` startet eine Coroutine, die die Route mit Zeitkompression abspielt, Marker in Intervallen setzt und Rotation an die Globusnormalen anpasst.
5. Marker-Management: begrenzte Anzahl/Lebensdauer via Culling und FIFO-Löschung, damit die Szene performant bleibt.

== Wichtige Parameter (Inspector)
- AirplaneMapper: `timeCompression`, `markerInterval`, `markerMaxCount`, `markerLifetimeSeconds`, `globeRadius`, `altitudeIsFeet`, `usePopularFromApi`, `popularCount`.
- Airplane: `customUp` (falls Globus-Lokalachse abweicht).
- SpinObject: `rotationSpeed` + UI-Slider-Binding.
- Kamera: `CameraMovement` für Editor/Debug (WASD, Shift, Space/Ctrl, Maus).

== Code-Hinweise
- Location-Parsing nutzt `JsonUtility`, daher müssen Feldnamen dem Backend entsprechen (snake_case). Lat/Lon werden als Strings mit invariant culture geparst; Altitude optional in Feet.
- Backend verwendet `worker_ready` Signal in Celery, um direkt nach Worker-Start einen ersten Fetch zu triggern und initiale Daten zu haben.
