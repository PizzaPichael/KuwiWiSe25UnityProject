= Design der Benutzeroberflächen

== Gestaltungsprinzipien
- Der Globus ist zentraler Anker: schwebend über dem Marker, klare Tag/Nacht-Beleuchtung und dezentes Atmosphären-Highlight.
- Marker sind leichtgewichtig, kontrastreich und zufällig gewählt, damit sich Pfade visuell unterscheiden, ohne das Bild zu überladen.
- UI bleibt minimal: nur die nötigsten Controls (Speed-Slider, Debug-Kamera-Hinweis) werden eingeblendet, wenn Tracking aktiv ist.

== Typografie & Farben
- TextMeshPro mit klarer Sans-Schrift; hohe Lesbarkeit auf hellem/transparentem Hintergrund.
- Globus-Material aus EarthRendering Free (Erde + Atmosphäre); Marker nutzen kräftige Farben für bessere Sichtbarkeit auf dem dunklen Meer.

== AR-spezifische Entscheidungen
- Canvas wird per Tracking-Events ein- und ausgeblendet, um UI-Flackern zu vermeiden, wenn das Target kurz verloren geht.
- Zeitkompression per Inspector-Parameter statt UI-Button, um die Fläche im AR-View minimal zu halten; Slider nur für Globe-Rotation.
- Kamera-Offset und Globe-Radius sind so gewählt, dass das Modell nicht in den Marker hineinragt und trotzdem im Sichtfeld bleibt.
