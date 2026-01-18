= Fazit <Fazit>

Das Projekt erreicht sein Ziel, Live-Flugrouten privater Maschinen auf einem AR-Globus sichtbar zu machen. Die Pipeline aus Celery-Worker, Django-API und Unity-Client funktioniert end-to-end: Daten werden regelmäßig gezogen, gespeichert und in der App als animierte Trajektorien mit Markern dargestellt.

Gelernt haben wir vor allem, AR-spezifische UX (ruhige UI, stabiles Tracking) mit performanter 3D-Visualisierung zu verbinden und dabei eine robuste Backend-Pipeline mit Rate-Limit-Schonung zu betreiben.

Mögliche nächste Schritte:
- Echtzeit-Streaming statt periodischer Pulls (z. B. WebSockets).
- Besseres Flugzeugmodell/Material und UI-Overlays für Geschwindigkeit/Höhe je Marker.
- Offline-Cache und Retry-Strategien bei instabilem Netz.
- Mehr Interaktion: Auswahl konkreter Tail-Numbers in der App, Filter nach Typ.
