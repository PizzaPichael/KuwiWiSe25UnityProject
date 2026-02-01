= Systemanforderungen <Systemanforderungen>
== Unity Anwendung
Zum Ausführen der Anwendung wird ein Grafikfähiger Windows-PC benötigt. Die grafischen Anforderungen der Anwendung sind gering und erfordern keine besonders starke Hardware. Falls die Anwendung direkt im Unity Editor ausgeführt werden soll, wird die Unity Version 6000.2.8f1 benötigt. Andernfalls wird zum ausführen der Anwendung keine externe Software benötigt.

Es wird eine Internetverbindung vorrausgesetzt, da die Daten die von der Anwendung vom Backend über das Internet bereitgestellt werden.

== Backend
Für das Django-Backend wird ein Server mit statischer IP-Adresse benötigt, welcher in der lage ist Python virtual-environments in der Version `3.12` auszuführen. Alternativ kann das Backend auch direkt (wie im deployment) per Docker-container ausgeführt werden. Folgende python-dependencies zum Ausführen des Backends benötigt:
```py
"celery>=5.5.3",
"django>=5.2.8",
"django-celery-beat>=2.8.1",
"django-celery-results>=2.6.0",
"django-debug-toolbar>=6.1.0",
"django-filter>=25.2",
"djangorestframework>=3.16.1",
"markdown>=3.10",
"python-dotenv>=1.2.1",
"requests>=2.32.5",
"psycopg[binary]>=3.2",
"gunicorn>=23.0.0",
"whitenoise>=6.6.0",
"drf-yasg>=1.21.11",
```
