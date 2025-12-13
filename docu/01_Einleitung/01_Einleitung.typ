= Einleitung

Dieses Projekt kombiniert eine Django-REST-API mit einer Unity-AR-Anwendung auf dem Smartphone. Die Backend-Pipeline sammelt regelmäßig Positionsdaten privater Flugzeuge von airplanes.live, speichert sie in einer Postgres/SQLite-Datenbank und stellt sie per API bereit. Die Unity-App nutzt Vuforia, um ein schwebendes 3D-Globus-Modell über ein Image-Target zu platzieren und spielt darauf Flugrouten samt Markern ab.

Ziel der Dokumentation ist, Architektur, verwendete Assets, Interaktion und getroffene technische Entscheidungen nachvollziehbar zu machen. Außerdem werden typische Probleme und Lösungsansätze festgehalten sowie ein Fazit mit möglichen Erweiterungen skizziert.

Beiträge im Team: Michael kümmerte sich hauptsächlich um AR-Interaktion und Globe/Marker-Visualisierung in Unity, David verantwortete die Django/Celery-Backend-Pipeline und die API-Integration in Unity. Beide arbeiteten gemeinsam an Tests der End-to-End-Kette (Backend → API → Globe).
