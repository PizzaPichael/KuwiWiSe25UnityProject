= Fazit <Fazit>

Im Verlaufe des Projektes mussten wir, unsere Zielsetzung immer wieder verwerfen und neu denken. Das letztendliche Ziel, Live-Flugrouten privater Flugzeuge auf einem AR-Globus sichtbar zu machen, wurde jedoch erfolgreich umgesetzt.

Die Pipeline aus Celery-Worker, Django-API und Unity-Client funktioniert end-to-end: Daten werden regelmäßig abgerufen, gespeichert und in der App als animierte Trajektorien mit Markern dargestellt.

Mögliche nächste Schritte:
- On demand Streaming statt periodischer Pulls (z. B. WebSockets von Backend zu Unity).
- Besseres Flugzeugmodell/Material und UI-Overlays für Geschwindigkeit/Höhe je Marker.
- Offline-Cache und Retry-Strategien bei instabilem Netz.
- Mehr Interaktion: Auswahl konkreter Tail-Numbers in der App, Filter nach Typ, Bilder von Flugzeugtypen.
- Vuforia für 3D visualisierung auf dem Smartphone.