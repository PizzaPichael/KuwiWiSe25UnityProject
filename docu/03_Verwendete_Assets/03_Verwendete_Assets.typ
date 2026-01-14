= Verwendete Assets und Bibliotheken
== Assets
Für das Projekt nutzen wir nur wenige Assets. Diese sind folgende:
- Erdball, eine 3D Repräsentation der Erde, um die herum die Flugzeuge fliegen sollen
- Low Poly Gulfstream, eine 3D repräsentation eines Gulfstream Flugzeugs, welches den privaten Charakter der von uns getrackten Flugzeuge vermitteln soll. Das Asset soll für jedes getrackte Flugzeug auf dem Globus gespawnt werden und die Flugroute verfolgen und veranschaulichen.
-

- *Vuforia Engine*: Image-Target-Tracking (Marker: `ImageTarget_Chips.png`) als Anker für den schwebenden Globus.
- *TextMeshPro*: UI-Schrift und Slider-Anzeigen (z. B. Rotationsgeschwindigkeit).
- *EarthRendering Free* und eigene Heightmap-Skripte: Globe- und Atmosphären-Shader, icosphere-basierte Meshes (`SphereGenerator`, `HeighMapper`).
- *Marker-Pack Prefab*: Zufällig gewählte Marker werden entlang der Flugroute platziert; Maximalanzahl und Lebensdauer sind konfigurierbar.
- *glTFast* (optional): Import von glTF-Modellen, falls alternative Flugzeugmodelle genutzt werden.
- *Backend-Bibliotheken*: Django, DRF, drf-yasg (Swagger/Redoc), Celery + django-celery-beat/-results, requests (API-Fetch), Whitenoise (Static Files), gunicorn.
- *Datenquelle*: https://api.airplanes.live/ als Live-ADS-B Feed für Flugzeugpositionen.
