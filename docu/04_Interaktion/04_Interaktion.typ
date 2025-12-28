= Interaktion

== Ablauf für Nutzende
- Bildmarker scannen: Kamera auf das Image-Target richten; das 3D-Globus-Setup erscheint an der Marker-Position.
- Globe beobachten: Flugzeugmodelle folgen ihrer aufgezeichneten Route über dem Globus; Marker zeigen Wegpunkte.
- UI ein-/ausblenden: Canvas wird automatisch mit Tracking aktiv/inaktiv geschaltet (`ShowHideUI`).
- Geschwindigkeit anpassen: Slider steuert Rotationsspeed des Globus (`SpinObject`); Zeitkompression der Routen ist im Inspector konfigurierbar.
- Freie Kamera (Debug/Editor): `CameraMovement` erlaubt WASD + Maus-Look + vertikale Bewegung, um die Szene ohne AR zu inspizieren.

== Datenfluss
- App lädt beim Start die beliebtesten Flugzeuge (oder vordefinierte Tail Numbers) aus dem Backend (`CoordinateFetcher`).
- Für jedes Flugzeug wird die Positionshistorie geholt, nach Weltkoordinaten gemappt und abgespielt (`AirplaneMapper` → `Airplane`).
- Marker werden in regelmäßigen Abständen entlang der Route gespawnt und automatisch begrenzt, damit die Szene performant bleibt.
