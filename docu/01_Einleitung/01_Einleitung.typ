= Einleitung

In Zeiten des Klimawandels ist der Flugverkehr ein wichtiges Thema, das immer wieder medial aufbereitet wird und eine breite Masse an Menschen betrifft. In den Medien wird unserer Auffassung nach vor allem viel darüber gesprochen, in wiefern Privatpersonen ihr Verhalten im Kontext Flugverkehr verändern oder gar einschränken sollten.
Als Reaktion darauf hört man häufig, dass der Fokus mehr auf Privatflügen von Menschen mit hohem Vermögen liegen sollte.
Nachzuvollziehen, welcher der beiden Bereiche, kommerzielle oder private Flüge, einen größeren Einfluss auf die Umwelt haben, ist allerdings gar nicht so einfach.
Statistiken wie die "Anzahl der einsteigenden Flugpassagiere bei Inlandsflügen in Deutschland in den Jahren 2017 bis 2024" @StatistischesBundesamt2025Inlandsfluege und "Anzahl der Privatflüge inklusive Geschäftsflüge in Deutschland von 2020 bis 2022" @CEDelft2023Privatfluege lassen zwar Vermutungen zu, ergeben aber aufgrund unterschiedlicher Zeiträume und Metriken kein klares Bild.

Dieses Problem wollten wir uns annähern. Uns war bekannt, dass es möglich ist über Dienste wie Flightradar24 @flightradar24 live Flugdaten zu verfolgen. Unsere Annahme war, dass man eine API eines solchen Dienstes nutzen könne, um mithilfe von Live-Daten und historischen Daten einen Flugtracker für die reichsten Menschen der Welt zu erstellen. Dieser sollte Flugdaten dreidimensional darstellen, indem Flugzeuge über eine Miniaturversion der Erde fliegen. Dieser Tracker sollte sowohl am Computer als auch auf einem Smartphone mittels Vuforia Image Tracking im 2D- sowie AR-Raum dargestellt werden können. Darauf aufbauend hätten in Zukunft dann weitere private Flüge sowie kommerzielle Flüge und Frachtverkehr ebenfalls dargestellt werden können.
Der Grund dafür, dass wir uns zuerst auf die Gruppe der reichsten Menschen der Welt konzentrieren wollten, war vor allem die Neugierde dafür, ob so etwas möglich ist, Flugdaten unter diese Gruppe fallender Menschen zu tracken und zu visualisieren.

Vor allem aufgrund der Schwierigkeit, Flugdaten generell allumfänglich abzufragen, sowie die Flugzeuge spezifischer Personen wie z.B. Elon Musk, Jeff Bezos oder Tailor Swift zu identifizieren, mussten wir unsere Umsetzung anpassen. Diese und weitere Problemstellungen werden im Kapitel @Problemlösung ausführlicher erläutert. Wir haben uns dazu entschieden, den zu Anfangs als in Aussicht stehenden Punkt der "weiteren privaten Flüge" in den Fokus zu stellen und mussten uns aufgrund von Zeitknappheit auf eine 2D-Anwendung beschränken.

Am Ende des Projektes steht nun eine Visualisierung von Flugdaten am Computer, der Flugzeugtypen, die am ehesten mit Privatflügen assoziiert werden. Gesammelt und gespeichert wurden diese Flugdaten mittels eines selbstgebauten Django-Backends, das über eine REST-API die Flugdaten abfragt, nach Flugzeugtypen filtert und in einer eigens erstellten Datenbank speichert. Diese Dokumentation erläutert Aufbau und Funktion der Visualisierung sowie des Backends.

== Aufgabenverteilung
- Michael:
  - Asset Recherche
  - Recherche nach Flugdaten APIs
  - Gestaltung der Unity Szene
  - Implementierung des UI und der Anzeige der Flugzeugdetails
  - Implementierung der Flugzeugauswahl
  - Implementierung der Player-Controlls
- David
  - Asset Recherche
  - Recherche nach Flugdaten APIs
  - Implementierung des Django Backends
  - Implementierung der API Kommunikation
  - Implementierung der Datenstruktur/Datenbank
  - Implementierung der Datenvisualisierung in Unity

/*
Dieses Projekt kombiniert eine Django-REST-API mit einer Unity-AR-Anwendung auf dem Smartphone. Die Backend-Pipeline sammelt regelmäßig Positionsdaten privater Flugzeuge von airplanes.live, speichert sie in einer Postgres/SQLite-Datenbank und stellt sie per API bereit. Die Unity-App nutzt Vuforia, um ein schwebendes 3D-Globus-Modell über ein Image-Target zu platzieren und spielt darauf Flugrouten samt Markern ab.

Ziel der Dokumentation ist, Architektur, verwendete Assets, Interaktion und getroffene technische Entscheidungen nachvollziehbar zu machen. Außerdem werden typische Probleme und Lösungsansätze festgehalten sowie ein Fazit mit möglichen Erweiterungen skizziert.

Beiträge im Team: Michael kümmerte sich hauptsächlich um AR-Interaktion und Globe/Marker-Visualisierung in Unity, David verantwortete die Django/Celery-Backend-Pipeline und die API-Integration in Unity. Beide arbeiteten gemeinsam an Tests der End-to-End-Kette (Backend → API → Globe).*/
