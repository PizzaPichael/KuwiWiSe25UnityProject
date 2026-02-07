#import "@preview/diatypst:0.9.0": *
#show: slides.with(
  title: "Visualizing private plane travel", // Required
  subtitle: "Kulturwissenschaften",
  date: "17.01.2026",
  authors: ("Michael Kaup", "David Kirchner"),
  ratio: 16 / 9,
  layout: "small",
  count: "number",
  toc: false
)

#let mycontents(body) = [
  #set text(size: 14pt)
  #set par(leading: .75em, spacing: 0.9em)
  #body
]

#let mytext(body) = [
  #set text(size: 14pt)
  #set par(leading: .75em, spacing: 1.2em)
  #body
]

#let myfigures(body) = [
  #set text(size: 8pt)
  #set par(leading: .75em, spacing: 1.2em)
  #body
]

== Contents

#mycontents[
  #block(inset: (left: 2.2em))[
    \
    1. @motivation
    #block(inset: (left: 1.2em))[
      2. @vergleichbare-projekte
      #block(inset: (left: 1.2em))[
        3. @systemarchitektur
        #block(inset: (left: 1.2em))[
          4. @unity-anwendung
          #block(inset: (left: 1.2em))[
            5. @interaktion
            #block(inset: (left: 1.2em))[
              6. @herausforderungen
              #block(inset: (left: 1.2em))[
                7. @demo
                #block(inset: (left: 1.2em))[
                  8. @ausblick + @fazit
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
]

= Motivation und Kontext<motivation>
== Projektidee
\
#mytext[
  - Flugverkehr im Kontext des Klimawandels
  - Diskussion: Privatpersonen vs. Privatflüge von Vermögenden
  - Schwierige Datenlage und fehlende Vergleichbarkeit
    - Unterschiedliche Zeiträume und Metriken in Statistiken
    - Kein klares Bild über tatsächliche Umweltauswirkungen
]

== Unsere Idee
\
#mytext[
  - Live-Tracking und Visualisierung von Privatflugdaten
  - 3D-Darstellung auf einem virtuellen Globus
  - Nutzung öffentlich verfügbarer ADS-B Daten
  - Fokus auf Flugzeugtypen typisch für Privatflüge
    - Ursprünglich: Tracking prominenter Personen (Musk, Bezos, Swift)
    - Anpassung: Typen wie Gulfstream, Cessna Citation
]

= Vergleichbare Projekte<vergleichbare-projekte>
== ElonJet
\
#mytext[
  - Automatisiertes Flight-Tracking System von Jack Sweeney
  - Postet die Position von Elon Musks Privatjet auf Twitter
  - Akkumuliert Flugzeit, Kosten und CO₂-Verbrauch
  - Kontroverse um Datenschutz vs. öffentliches Interesse
]

#pagebreak()
#columns(2)[
  #figure(
    image("assets/ElonJet.png", width: 80%),
    caption: [ElonJet Twitter Feed],
  )
  #align(horizon)[
    #figure(
      image("assets/ElonJetFuelUsage.png", width: 100%),
      caption: [CO₂-Verbrauch Visualisierung],
    )
  ]
]

== Architects of the Apocalypse
\
#mytext[
  - Visualisierung aller Privatjet-Flüge von Tech-Milliardären
    - Bill Gates, Jeff Bezos, Mark Zuckerberg, Elon Musk
    - Zeitraum: Juli 2021 – Juli 2022
  - Datenquelle: ADS-B Exchange
  - Pfeile gewichtet nach kumulativen CO₂-Emissionen
  - Künstlerische Kritik an Ressourcenverschwendung
]

#pagebreak()
\
#figure(
  image("assets/Architects-of-the-Apocalypse-Thumbnail-1200x536.png", width: 80%),
  caption: [Architects of the Apocalypse],
)

= Systemarchitektur<systemarchitektur>
== Übersicht
\
#mytext[
  *Backend (Django + Celery)*
  - Regelmäßige Datenabfrage von airplanes.live API
  - Speicherung in Postgres-Datenbank
  - REST-API für Unity-Client

  *Frontend (Unity)*
  - 3D-Globus-Visualisierung
  - Interaktive Flugzeugauswahl
  - Echtzeit-Datenvisualisierung
]

== Backend: Technische Details
#columns(2)[
#mytext[
  \
- *Django Python-Framework*
  - REST-API für Flugdaten
  - Django-Rest-Framework

- *Celery Beat Task Scheduler*
  - Automatisierte API-Abfragen
  - Alle 5 Minuten
  - 1 Sekunde Pause pro Flugzeugtyp

\
- *Datenvalidierung*
  - Tail-Number-Validierung
  - Höhenangaben-Normalisierung
]
#figure(
  image("./assets/Models.png", width: 83%),
  caption: [Relationales Datenmodell]
)
]

== Django Admin Interface
\
#columns(2)[
  #figure(
    image("./assets/DjangoAdmin.png", width: 100%),
    caption: [Admin Übersicht],
  )
  #figure(
    image("./assets/Aiplane.png", width: 100%),
    caption: [Flugzeug-Details],
  )
]

== API-Dokumentation
\
#mytext[
  *Vollständiges API-Schema verfügbar unter:*

  #link("https://flights.davidkirchner.de/swagger")

  *Endpoints:*
  - `/api/airplanes/` - Alle Flugzeuge
  - `/api/airplanes/{tail}/` - Spezifisches Flugzeug
  - `/api/airplanes/popular/` - Populäre Flugzeuge
  - `/api/locations/` - Alle Positionsdaten
]

= Unity Anwendung<unity-anwendung>
== Hauptkomponenten
\
#mytext[
  *AirplaneMapper*
  - Verwaltung der Flugzeug-Objekte
  - Marker-Lifecycle-Management
  - Integration mit CoordinateFetcher

  *PlayerController*
  - Kamera-Steuerung (WASD + Maus)
  - Zwei Modi: UI-Modus und Bewegungsmodus
  - Konfigurierbare Bewegungsparameter

  *ClickPlaneManager*
  - Flugzeugauswahl per Raycast
  - Anzeige von Flugdetails im UI
  - Visual Feedback (Outline)
]

== Datenfluss
\
#mytext[
  1. *CoordinateFetcher* ruft Django-API ab
  2. *JSON-Daten* werden in 3D-Koordinaten umgewandelt
    - Latitude/Longitude → 3D-Position auf Globus
    - Altitude → Radialer Offset
  3. *Flugzeug-Prefabs* werden instanziiert
  4. *Coroutine* spielt Route zeitkomprimiert ab
  5. *Marker* werden in Intervallen gesetzt (FIFO)
  6. *Rotation* wird an Globus-Normale angepasst
]

= Interaktion<interaktion>
== Steuerung
#figure(
      image("./assets/screenshots/MainMenuUI.png", width: 75%),
      caption: [Hauptmenü],
    )

== Steuerung
\
#mytext[
  
    #figure(
      image("./assets/screenshots/MoveControlls.gif", width: 60%),
      caption: [Kamerabewegung mit der Tastatur],
    )

    #figure(
      image("./assets/screenshots/LookControls.gif", width: 60%),
      caption: [Kamera Drehung mit der Maus],
    )
]

== Flugzeugauswahl
\
#myfigures[
  
  #columns(2, gutter: 1.2em)[
    #figure(
      image("./assets/screenshots/cursor.png", width: 50%),
      caption: [Cursor für die Auswahl von Flugzeugen],
    )
    #figure(
      image("./assets/screenshots/planeselected.png", width: 60%),
      caption: [Flugzeug hervorgehoben nach Auswahl],
    )
  ]
\
\
\
\
\
\
  #columns(2, gutter: 1.2em)[
    #figure(
      image("./assets/screenshots/plane_HUD.png", width: 90%),
      caption: [HUD mit Flugzeuginformationen],
    )
    #figure(
      image("./assets/screenshots/Flightcomputer.png", width: 80%),
      caption: [HUD mit Beschreibung der Controls],
    )
  ]
]

= Herausforderungen<herausforderungen>
== API und Daten
\
#mytext[
  *API-Ratenbegrenzung*
  - Künstliche Pausen (1 Sek. pro Typ)
  - Moderates Abfrage-Intervall (5 Min.)
  - Vermeidung von API-Sperren

  *Datenbeschaffung und -bereinigung*
  - Kostenlose vs. kostenpflichtige Datenquellen
  - Validierung der Tail-Number-Länge
  - Filterung fehlerhafter Datensätze

  \

  *Zeitseriendaten*
  - Normalisierung der Zeitkomponente
  - Alle Daten als gleichzeitig angezeigt
  - Vereinfachte Analyse
]

== Performance und Abdeckung
#mytext[
  \
  *Marker-Performance*
  - Definierte Marker-Lebensdauer
  - Stabile Framerate

  *Geografische Abdeckung*
  - Nordamerika: Sehr hoch
  - Europa: Mittel
  - Asien/Globaler Süden: Gering
  - Crowdsourcing-bedingte Unterschiede
]

== Tracking-Problematik
#mytext[
  \
  *Prominente Personen*
  - FAA-Blockade von Registrationsdaten
  - Privatjet-Owner können Daten verbergen
  - Registrationsnummern nicht auffindbar

  *Unsere Lösung*
  - Umstellung auf Flugzeugtypen
  - Fokus auf typische Privatjet-Modelle
  - Gulfstream, Cessna Citation, Bombardier

  \

  *Datenverfügbarkeit*
  - Keine historischen Daten (kostenpflichtig)
  - Eigene Datensammlung über Live-API
  - airplanes.live als kostenlose Alternative
]

= Demo<demo>

= Ausblick<ausblick>
== Mögliche Erweiterungen
\
#mytext[
  *Technische Verbesserungen*
  - WebSocket-Integration für Echtzeit-Streaming
  - Offline-Cache und Retry-Strategien
  - Verbesserte 3D-Modelle und Materialien
  - UI-Overlays für Geschwindigkeit/Höhe je Marker

  *Funktionale Erweiterungen*
  - Erweiterte Filteroptionen (Typ, Region, Zeitraum)
  - Integration kommerzieller Flüge zum Vergleich
]

= Fazit<fazit>
== Projektergebnis
\
#mytext[
  *Erfolge*
  - Vollständige End-to-End-Pipeline funktionsfähig
  - Robuste Backend-Architektur mit Django + Celery
  - Intuitive 3D-Visualisierung in Unity
  - Pragmatische Lösungen für komplexe Probleme

  *Erkenntnisse*
  - Grenzen öffentlicher Flugdatenverfügbarkeit
  - Regulatorische Hürden (FAA-Blockade)
  - Performance-Optimierung bei großen Datenmengen
  - Wert von flexiblem Umdenken bei Hindernissen
]

= Vielen Dank für Ihre Aufmerksamkeit!<danke>
\
#align(center + horizon)[
  #mytext[
    *Fragen?*

    \
    \

    API: #link("https://flights.davidkirchner.de/swagger")

    Michael Kaup | David Kirchner
  ]
]
