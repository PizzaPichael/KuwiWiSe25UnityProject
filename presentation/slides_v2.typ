#import "@preview/diatypst:0.9.0": *
#show: slides.with(
  title: "Visualizing private plane travel", // Required
  subtitle: "Kulturwissenschaft",
  date: "11.02.2026",
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
                  8. @ausblick
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
#align(horizon)[
  #columns(2)[
    #figure(
      image("assets/screenshots/statistic_id1467900_entwicklung-des-passagieraufkommens-bei-inlandsfluegen-in-deutschland-bis-2024.png", width: 100%),
      caption: [Anzahl der einsteigenden Flugpassagiere bei Inlandsflügen in Deutschland in den Jahren 2017 bis 2024],
    )
    #figure(
      image("assets/screenshots/statistic_id1389719_anzahl-der-privatfluege-inklusive-geschaeftsfluege-in-deutschland-bis-2022.png", width: 100%),
      caption: [Anzahl der Privatflüge inklusive Geschäftsflüge in Deutschland von 2020 bis 2022],
    )
  ]
]
#place(
  bottom + right,
  dx: -0em,
  dy: -0em,
  text(size: 8pt)[[Statista Research Dept., 2025 ]],
)
#pagebreak()
\
#mytext[
  - Live-Tracking & Visualisierung von Privatflugdaten
  - 3D-Darstellung auf virtuellem Globus
  - Öffentlich verfügbare ADS-B Daten
  - Ursprünglich: Tracking prominenter Personen (Musk, Bezos, Swift)
  - Anpassung: Fokus auf Flugzeugtypen typisch für Privatflüge
     - z.B. Gulfstream, Cessna, etc.
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
  #place(
  bottom + right,
  dx: -0em,
  dy: -0em,
  text(size: 8pt)[[Wikipedia, 2025 ], [Mastodon, 2026 ]],
)
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
  image("assets/Architects-of-the-Apocalypse-Thumbnail-1200x536.png", width: 75%),
  caption: [Architects of the Apocalypse],
)
#place(
  bottom + right,
  dx: -0em,
  dy: -0em,
  text(size: 8pt)[[University of Wisconsin-Madison, 2024]],
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
]

#pagebreak()
#align(center)[
    #figure(
      image("./assets/Models.png", height: 95%),
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

  #columns(2)[
    #mytext[
  *AirplaneMapper*
  - Verwaltung der Flugzeug-Objekte
  - Marker-Lifecycle-Management
  - Integration mit CoordinateFetcher
    ]
  #align(horizon)[
    #figure(
        image("./assets/screenshots/AirplaneMapper.png", width: 60%),
        caption: [AirplaneMapper Komponente],
      )
    ]
  ]

  #pagebreak()

  #columns(2)[
    \
    #mytext[
      *PlayerController*
      - Kamera-Steuerung (WASD + Maus)
      - Zwei Modi: UI-Modus und Bewegungsmodus
      - Konfigurierbare Bewegungsparameter
    ]
    #align(horizon)[
      #figure(
          image("./assets/screenshots/PlayerController.png", width: 80%),
          caption: [PlayerController Komponente],
        )
    ]
  ]

  #pagebreak()

  #columns(2)[
    \
    #mytext[
    *ClickPlaneManager*
    - Flugzeugauswahl per Raycast
    - Anzeige von Flugdetails im UI
    - Visual Feedback (Outline)
    - Schließender UI
    ]
    #align(horizon)[
      #figure(
          image("./assets/screenshots/ClickPlaneManager.png", width: 80%),
          caption: [ClickPlaneManager Komponente],
        )
    ]
  ]
  

== Datenfluss
#figure(
        image("./assets/screenshots/Datenfluss.png", height: 95%),
        caption: [ClickPlaneManager Komponente],
      )

= Interaktion<interaktion>
== Hauptmenü
#figure(
      image("./assets/screenshots/MainMenuUI.png", width: 75%),
      caption: [Hauptmenü],
    )

== Controls
#figure(
      image("./assets/screenshots/Flightcomputer.png", width: 75%),
      caption: [HUD mit Beschreibung der Controls],
    )

#figure(
      image("./assets/screenshots/MoveControlls.gif", width: 75%),
      caption: [Kamerabewegung],
    )

#figure(
      image("./assets/screenshots/LookControls.gif", width: 75%),
      caption: [Kameradrehung],
    )

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

#columns(1, gutter: 1.2em)[
  #figure(
    image("./assets/screenshots/plane_HUD.png", width: 75%),
    caption: [HUD mit Flugzeuginformationen],
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
]

#pagebreak()
\
#mytext[
  *Datenbeschaffung und -bereinigung*
  - Keine historischen Daten (kostenpflichtig)
  - airplanes.live als kostenlose Alternative
  - Eigene Datensammlung über Live-API
  - Validierung der Tail-Number-Länge
  - Filterung fehlerhafter Datensätze
]

== Abdeckung
\
#mytext[
  *Geografische Abdeckung*
  - Nordamerika: Sehr hoch
  - Europa: Mittel
  - Asien/Globaler Süden: Gering
  - Crowdsourcing-bedingte Unterschiede
]


== Tracking-Problematik
\
#mytext[
  *Prominente Personen*
  - FAA-Blockade von Registrationsdaten
  - Privatjet-Owner können Daten verbergen
  - Registrationsnummern nicht auffindbar

  *Unsere Lösung*
  - Umstellung auf Flugzeugtypen
  - Fokus auf typische Privatjet-Modelle
  - Gulfstream, Cessna Citation, Bombardier
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

= Vielen Dank für eure Aufmerksamkeit!<danke>

== Fragen
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

= Quellen
== Quellen
\
  1. Statista Research Department: _Passagieraufkommen bei Inlandsfluegen in Deutschland 2023._ Statista, 2025. \
    #link("https://de.statista.com/statistik/daten/studie/1467900/umfrage/passagieraufkommen-bei-inlandsfluegen-in-deutschland-2023/") — Zugriff am 11.02.2026
  2. Statista Research Department: _Anzahl Privatfluege und Geschaeftsfluege in Deutschland._ Statista, 2025. \
    #link("https://de.statista.com/statistik/daten/studie/1389719/umfrage/anzahl-privatfluege-und-geschaeftsfluege-in-deutschland/") — Zugriff am 11.02.2026
  3. Mastodon: _atelonjet._ Mastodon.social, 2026. \
    #link("https://mastodon.social/@elonjet") — Zugriff am 11.02.2026
  4. Wikipedia: _ElonJet._ Wikipedia, 2025. \
    #link("https://en.wikipedia.org/wiki/ElonJet") — Zugriff am 11.02.2026
  \
  5. University of Wisconsin-Madison DesignLab: _Architects of the Apocalypse._ DesignLab, 2024. \
    #link("https://designlab.wisc.edu/architects-of-the-apocalypse/") — Zugriff am 11.02.2026


