= Problemlösung <Problemlösung>

Im Rahmen der Implementierung ergaben sich verschiedene technische Herausforderungen bezüglich der API-Nutzung, der Performance und der Datenqualität, die durch gezielte Maßnahmen adressiert wurden.

== API-Ratenbegrenzung und Datenbereinigung
Ein kritischer Aspekt war der Umgang mit der airplanes.live API, die nicht zu aggressiv abgefragt werden darf, um Sperren zu vermeiden. Als Lösung wurde eine künstliche Pause (`sleep`) von einer Sekunde pro abgefragtem Flugzeugtyp sowie ein moderates gesamt-abfrage-Intervall von fünf Minuten eingeführt. Zusätzlich implementierten wir einen Validierungscheck für die Länge der "Tail Number", um fehlerhafte oder unvollständige Datensätze frühzeitig herauszufiltern. Ein weiteres Datenproblem betraf Höhenangaben, die lediglich als "ground" zurückgegeben wurden; diese werden nun systemintern in den numerischen Wert -1 umgewandelt, um sie eindeutig als nicht-fliegende Objekte zu kennzeichnen.

== Marker-Performance
Die Darstellung einer großen Anzahl von Markern führte initial zu spürbaren Einbrüchen der Bildwiederholrate (Framerate). Um die Performance zu stabilisieren, wurde eine konfigurierbare Obergrenze für die Marker-Anzahl sowie eine definierte Lebensdauer eingeführt. Überschüssige Marker werden nun nach dem FIFO-Prinzip (First-In, First-Out) entfernt, sodass stets nur die aktuellsten relevanten Daten visualisiert werden, ohne die Render-Leistung zu überlasten.

== Zeitseriendaten und Visualisierung
Bei der Verarbeitung der zeitbasierten Daten zeigte sich, dass eine Darstellung entsprechend der tatsächlichen Beobachtungszeiträume zu einer extremen zeitlichen Streckung führte. Um die Analyse zu vereinfachen und die visuelle Dichte zu erhöhen, haben wir uns dazu entschlossen, die zeitliche Komponente zu normalisieren und alle in einem Zyklus gesammelten Daten so anzuzeigen, als wären sie zum selben Zeitpunkt aufgetreten.

== Abdeckung der ADS-B Daten
Die Verfügbarkeit der ADS-B Daten ist geografisch stark inkonsistent. Während Nordamerika eine sehr hohe Abdeckung aufweist, ist die Datendichte in Europa bereits geringer und nimmt im globalen Süden sowie in Asien noch weiter ab. Dies lässt sich darauf zurückführen, dass die verwendete ADS-B Datenbank primär durch die Community gespeist wird ("Crowdsourcing"). In Nordamerika ist die Dichte an Hobbyisten, die private ADS-B Empfänger betreiben und Daten einspeisen, schlicht am höchsten, was die geografische Diskrepanz erklären könnte.
