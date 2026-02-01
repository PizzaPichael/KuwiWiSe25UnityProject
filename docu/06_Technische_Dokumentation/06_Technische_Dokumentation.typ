= Technische Dokumentation <TechnischeDoku>

== Backend
Zum sammeln und bereitstellen der Positionsdaten der Privatejets haben wir ein Backend mit dem Python Framework `Django` implementiert. Um die Positionsdaten zu sammlen wir die öffentlich und kostenlos zugängliche API von #link("https://airplanes.live/api-guide/")[Airplanes.live] abgefragt. Wie in @datamodel zusehen wurde zum speichern der abgefragen Daten wurde ein simples Datenbankmodell entwickelt.

#figure(
  caption: [Relationales Daten-Modell],
  image("../assets/Models.png", width: 50%),
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
  ```,
)<celery_beat_schedule>

Zum Administrieren der Daten wurde das Admin-Interface von Django konfiguriert. Hier können alle gesammelten `Airplanes` und `Locations` eingesehen und bearbeitet werden.

#figure(
  caption: [Django Admin Interface],
  image("../assets/DjangoAdmin.png", width: 70%),
)<django_admin_interface>

Jedes `Airplane` hat eine one to many realtionship mit `Location`. Wie in @airplane zu sehen, kann jedes `Airplane` und seine zugehörigen `Location`´s eingesehen und bearbeitet werden.

#figure(
  caption: [Django Admin Interface],
  image("../assets/Aiplane.png", width: 100%),
)<airplane>

Das vollständige API-Schema kann unter #link("https://flights.davidkirchner.de/swagger")[https://flights.davidkirchner.de/swagger] eingesehen werden.

== Unity Anwendung

Die Stuktur der Unity Anwendung besteht aus 3 Hauptkomponenten. Den `AirplaneMapper`, dem `PlayerController` und dem `ClickPlaneManager`.


=== AirplaneMapper Airplane und CoordinateFetcher

Im `AirplaneMapper` liegen alle veranwortlichkeiten zum Anzeigen der Flugzeuge auf dem Erdball. Er kontrolliert lifetimes für die `Airplane` und `Indicator` Objekte. Zusätzlich nutzt dieser den `CoordinateFetcher` zum Abrufen der Daten von Backend und zum instanziieren der `Airplane` Objekte.

Jedes `Airplane` ist für das abspielen seiner Positionsdaten und das spawnen und zerstören von den zugehörigen Positionsmarker verantwortlich.


=== PlayerController

Der `PlayerController` beinhaltet alle Funktionalitäten die zum bewegen der Kamera benötigt werden. Es werden mehrere Eventlistener verwendet um die Bewegung der Maus und Tastendrücke abzufangen und zu behandeln. Der `PlayerController` hat durch den Inspector einstellbare attribute welche die Mausempfindlichkeit, die Winkelgrenzen und die Bewegungsgeschwindigkeit steuern.


=== ClickPlaneManager

Der `ClickPlaneManager` ist für die Spielerinteraktionen mit den Flugzeugen verantwortlich. Durch einen Linksclick wird ein Strahl aus der Mitte der Kamera ausgesendet und überprüft ob das getroffene Objekt den tag `airplane` besitzt. Falls dies der fall ist, über das `Transform` des Objekts das zugehörige `Airplane` abgerufen. Nun wird eine Outline um das Mesh des Airplane Objekts gelegt und die zugehörigen Flugdaten (tailnumber, type, height, speed, heading, latitude, longitude) eingelesen. Dann wird das erstellte Flugdaten Userinterface eingeblendet und die Daten eingefügt.


== Unity-Datenfluss
1. `AirplaneMapper` startet im AR-Scene-Setup und lädt per `CoordinateFetcher` wahlweise populäre Flugzeuge oder eine Liste aus dem Inspector.
2. `CoordinateFetcher` konsumiert die Django-API und liefert JSON-Responses für Tail-Number oder Popular-Endpunkt.
3. `ListCoordinateMapper` wandelt jede Location in Weltkoordinaten auf dem Globus um (Lat/Lon → 3D-Richtung, Altitude -> radialer Offset, sortiert nach Timestamp).
4. Für jedes Flugzeug wird ein Prefab instanziiert (`Airplane`-Komponente). `Airplane.Initialize` startet eine Coroutine, die die Route mit Zeitkompression abspielt, Marker in Intervallen setzt und Rotation an die Globusnormalen anpasst.
5. Marker-Management: begrenzte Anzahl/Lebensdauer via Culling und FIFO-Löschung, damit die Szene performant bleibt.
