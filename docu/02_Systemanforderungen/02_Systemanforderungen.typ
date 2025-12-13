= Systemanforderungen

== Hardware
- Smartphone mit Kamera (Android oder iOS) für die AR-Anzeige.
- Entwicklungsrechner mit GPU-beschleunigter Unity-Editor-Unterstützung; 16 GB RAM empfohlen.

== Software
- Unity 6000.2.8f1 (Unity 6) inkl. Android/iOS Build Support.
- Vuforia Engine (AR-Tracking via Image-Target), TextMeshPro, glTFast (für glTF-Import falls benötigt).
- Python >= 3.12, Django 5.2, Django REST Framework, Celery 5.5 mit RabbitMQ, Postgres 16 (alternativ SQLite für lokal).
- Docker + Docker Compose für reproduzierbare Backends (Services: web, worker, beat, rabbitmq, db).

== Umgebungsvariablen (Backend)
- `DATABASE_URL` (Postgres-URL) oder Default: SQLite.
- `CELERY_BROKER_URL` (Default: amqp://guest:guest@localhost:5672//).
- `CELERY_RESULT_BACKEND` (Default: django-db).
- `ALLOWED_HOSTS`, `CSRF_TRUSTED_ORIGINS`, `DEBUG` für Deployment.

== Netz
- Internetzugriff auf https://api.airplanes.live/ (Live-Daten).
- Lokale Ports: 8000 (Django/Swagger), 5672 (RabbitMQ), 5432 (Postgres in Docker).
