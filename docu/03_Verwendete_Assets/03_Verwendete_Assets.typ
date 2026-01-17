= Verwendete Assets und Bibliotheken
== Assets
Für das Projekt nutzen wir folgende Assets:
- *Earth*: eine 3D Repräsentation der Erde, um die herum die Flugzeuge fliegen sollen, Quelle siehe 4.2 Unity Packages, EarthRendering Free
- *Low Poly Gulfstream* @lowpoly-gulfstream: eine 3D repräsentation eines Gulfstream Flugzeugs, welches den privaten Charakter der von uns getrackten Flugzeuge vermitteln soll. Das Asset soll für jedes getrackte Flugzeug auf dem Globus gespawnt werden und die Flugroute verfolgen und veranschaulichen.
- *Low Poly Cloud Pack* @cloud-pack: wird verwendet um zufällige Wolken Modelle auf den Flugbahnen der Flugzeuge zu spawnen, um deren Flugroute nachverfolgen zu können.
- *FlighComputerImage* @flightcomputer-thumbnail: Abbildung eiens Flugcomputerbildschirms, wird genutzt um Flugdaten eines Flugzeuges nach Auswahl des Flugzeuges darzustellen.
- *Milkyway Skybox* @sky-box: Bild eines Milchstraßen Panoramas, das, auf eine Kugel projeziert, als Skybox der Scene genutzt wird.

== Unity Packages
Folgende Packages haben wir über den Unity-Package-Manager in unser Projekt integriert:
- *Vuforia Engine*: Image-Target-Tracking als Anker für den schwebenden Globus.
- *TextMeshPro*: Hinzufügen von UI-Schrift Elementen.
- *EarthRendering Free* : stellt das 3D Asset des Erdballs<earthrendering>.
- *glTFast* (optional): Import von glTF-Modellen.

== Sonstiges
Folgende Weitere Tools und Quellen nutzen wir für das Projekt:
- *Backend-Bibliotheken*: Django, DRF, drf-yasg (Swagger/Redoc), Celery + django-celery-beat/-results, requests (API-Fetch), Whitenoise (Static Files), gunicorn.
- *airplanes.live API* @airplanes-api: Unsere Datenquelle, von der wir die Flugdaten der Flugzeuge als Live-ADS-B Feed beziehen.
