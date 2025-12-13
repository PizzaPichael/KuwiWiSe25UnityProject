= Technische Dokumentation

== Backend

Zum sammeln und bereitstellen der Positionsdaten der Privatejets haben wir ein Backend mit dem Python Framework `Django` implementiert. Um die Positionsdaten zu sammlen wir die öffentlich und kostenlos zugängliche API von #link("https://airplanes.live/api-guide/")[Airplanes.live] abgefragt. Wie in @datamodel zusehen wurde zum speichern der abgefragen Daten wurde ein simples Datenbankmodell entwickelt. 

#figure(
  caption: [Datamodel],
  image("../assets/Models.png", width: 30%)
)<datamodel>

Das Python package `Celery` wird verwendet um Tasks asynchron auszuführen. Wir verwenden den Celery Task Scheduler `Beat` um in regelmäßigen Zeitintervallen die Abfragen durchzuführen. Wie in @celery_beat_schedule zu sehen, fragen wir die API alle 5 Minuten ab.

#figure(
caption: [Celery Beat Schedule],
```py
app.conf.beat_schedule = {
    "fetch-airplane-positions": {
        "task": "api.tasks.fetch_data",
        "schedule": 300.0,
    },
}
```
)<celery_beat_schedule>

Zum Administrieren der Daten wurde das Admin-Interface von Django konfiguriert. Hier können alle gesammelten `Airplanes` und `Locations` eingesehen und bearbeitet werden.

#figure(
  caption: [Django Admin Interface],
  image("../assets/DjangoAdmin.png", width: 70%)
)<django_admin_interface>

Jedes `Airplane` hat eine one to many realtionship mit `Location`. Wie in @airplane zu sehen, kann jedes `Airplane` und seine zugehörigen `Location`´s eingesehen und bearbeitet werden. 

#figure(
  caption: [Django Admin Interface],
  image("../assets/Aiplane.png", width: 100%)
)<airplane>

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
