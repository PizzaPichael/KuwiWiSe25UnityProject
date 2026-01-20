= Fazit <Fazit>

Im Verlaufe des Projektes mussten wir, unsere Zielsetzung immer wieder verwerfen und neu denken. Das letztendliche Ziel, Live-Flugrouten privater Flugzeuge auf einem AR-Globus sichtbar zu machen, wurde jedoch erfolgreich umgesetzt.

Die Pipeline aus Celery-Worker, Django-API und Unity-Client funktioniert end-to-end: Daten werden regelmäßig abgerufen, gespeichert und in der App als animierte Trajektorien mit Markern dargestellt.

Mögliche nächste Schritte:
- Echtzeit-Streaming statt periodischer Pulls (z. B. WebSockets).
- Besseres Flugzeugmodell/Material und UI-Overlays für Geschwindigkeit/Höhe je Marker.
- Offline-Cache und Retry-Strategien bei instabilem Netz.
- Mehr Interaktion: Auswahl konkreter Tail-Numbers in der App, Filter nach Typ.

== Abschließende Bewertung

Dieses Projekt demonstriert eine erfolgreiche Umsetzung eines komplexen Systems bestehend aus Backend, API und interaktiver Visualisierung. Der ursprüngliche Anspruch, prominente Privatflüge in Echtzeit zu tracken und visuell aufzuarbeiten, scheiterte zwar an technischen und regulatorischen Hürden – insbesondere der FAA-Blockade von Registrationsdaten und der Unvollständigkeit freier ADS-B-Datenquellen. Dies führte jedoch nicht zum Scheitern des Projekts, sondern zu einer pragmatischen Neuausrichtung: Statt einzelner prominenter Personen werden nun Flugzeugtypen typisch privater Luftfahrt visualisiert, was für eine Analyse des Flugaufkommens ebenso aussagekräftig ist.

Technisch gelang es, die Gesamtkette von der Datenerfassung über die Datenbank und API bis zur grafischen Darstellung robust zu implementieren. Die Architektur mit asynchronen Celery-Tasks für periodische Datenabfragen, einem strukturierten Django-Backend und einer schlanken REST-API hat sich als wartbar und skalierbar erwiesen. Der Unity-Client demonstriert intuitives 3D-Interface-Design: Die Kombination aus Tastatur-/Mausbewegung und raycast-basierter Objektwahl ermöglicht intuitive Exploration der globalen Flugdaten.

Besondere Herausforderungen ergaben sich bei der Handhabung von Rate-Limiting-Mechanismen, der Performance-Optimierung bei der Marker-Darstellung und der geografischen Dateninkonistenz (ADS-B-Abdeckung ist stark Nordamerika-zentriert). Durch konfigurierbare Limits, FIFO-basiertes Marker-Culling und validierte Dateneingabe wurden diese Probleme pragmatisch gelöst.

Die Dokumentation, unterteilt nach Einleitung, Anforderungen, Assets, Interaktion, UI-Design, technischer Dokumentation, Problemlösung und Fazit, schafft eine umfassende Grundlage zum Verständnis und zur Wartung des Systems. Aufgabenverteilung und Rollen sind klar definiert, mit Michael verantwortlich für Frontend und Interaction, David für Backend und Datenintegration.

Zusammenfassend steht am Ende des Projekts nicht nur eine funktionale Anwendung, sondern auch wertvolles Wissen über die Machbarkeit und Grenzen öffentlicher Flugdatenverfügbarkeit, über AR-Design und über die Integration verteilter Systeme. Die geschaffene Basis bietet optimale Voraussetzungen für zukünftige Erweiterungen – sei es durch WebSocket-Integration, verbesserte Datenquellen oder erweiterte Filteroptionen. Das Projekt zeigt, dass ambitionierte Ziele durch flexibles Umdenken und technische Exzellenz realisierbar sind.
