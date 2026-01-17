= Problemlösung

== API-Raten & Datenqualität
- Issue: airplanes.live darf nicht zu aggressiv abgefragt werden. Lösung: 1s Pause pro Typ (`sleep`), moderate Beat-Intervalle (5 min) und Tail-Number-Längencheck, um kaputte Datensätze zu filtern.
- Issue: "ground" als Höhenwert. Lösung: Umwandlung in -1, damit erkennbar kein echter Flug.

== Initialbefüllung
- Issue: Worker startete, bevor der Broker bereit war; erster Fetch ging verloren. Lösung: Celery `worker_ready` Signal sendet sofort einen Fetch-Task, sobald der Worker läuft.

== Marker-Performance
- Issue: Viele Marker ließen die Framerate fallen. Lösung: konfigurierbare Maximalanzahl + Lebensdauer, FIFO-Löschung ältester Marker.

== Koordinatentransformation
- Issue: Unterschiedliche Zeitzonen/Formats. Lösung: `DateTime.TryParse` mit invariant culture + Sortierung nach Timestamp.
- Issue: Altitude in Feet vs. Meter. Lösung: konfigurierbarer Modus `altitudeIsFeet` mit Umrechnung 0.3048.

== AR-UX
- Issue: UI flackerte beim Verlust des Targets. Lösung: Canvas aktiv/inaktiv via `ShowHideUI` auf Tracking-Events.

== Zeitseriendaten
- Die Daten waren extrem in die länge gezogen wenn man sie entsprechend ihrerer Beobachtungszeit angezeigt hat. Hier haben wir uns dazu entschlossen, alle gesammelten Daten zum selben Zeitpunkt anzuzeigen.