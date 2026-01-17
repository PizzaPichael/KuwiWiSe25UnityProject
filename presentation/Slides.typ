#import "@preview/diatypst:0.9.0": *
#show: slides.with(
  title: "Visualiszing private plane travel", // Required
  subtitle: "Kulturwissenschaften",
  date: "17.01.2026",
  authors: ("Michael Kaup", "David Kirchner"),
  ratio: 16/9,
  layout: "small"
)

#let mytext(body) = [
  #set text(size: 14pt)
  #set par(leading: .75em, spacing: 1.2em)
  #body
]

= Konzept und Idee
== Konzept und Idee
\
#mytext[

- Visualisierung von Privatejet flügen

]


= Vergleichbare Projekte in Kunst & Kultur
== ElonJet
\
#mytext[
- Automatisiertes Flight-Tracking System von Jack Sweeney
- Postet die Position von Elon Musks Privatjet auf Twitter
- Akkumuliert Flugzeit, Kosten und CO2 verbrauch
]

#pagebreak()
#columns(2)[
  #figure(
    image("assets/ElonJet.png", width: 80%),
    caption: [
      ElonJet
    ],
  )
  #align(horizon)[
    #figure(
      image("assets/ElonJetFuelUsage.png", width: 100%),
      caption: [
        ElonJet
      ],
    )
  ]
]


== Architects of the Apocalypse
\
\
#mytext[
- Alle Privatjet-Flüge von Bill Gates, Jeff Bezos, Mark Zuckerberg und Elon Musk zwischen Juli 2021–2022

- Öffentlich verfügbare ADS-B Exchange Daten; Pfeile gewichtet nach kumulativen CO₂-Emissionen zwischen Städten

- Kritik an absurder Ressourcenverschwendung durch die Ultra-Reichen
]

#pagebreak()
\
#figure(
  image("assets/Architects-of-the-Apocalypse-Thumbnail-1200x536.png", width: 80%),
  caption: [
    Architects of the Apocalypse
  ],
)


= Technische Umsetzung und Besonderheiten
== Backend

#columns(2)[
#mytext[
- Django Python-Framework

- Rest-API zum abfragen der gesammelten Flugdaten

- Django-Rest-Framework
  - vorimplementierte API-Views

- Celery-Beat Task scheduler

- Regelmäßige Abfrage der Airplanes.live API

]
#figure(
  image("./assets/Models.png", width: 80%),
  caption: [Datenmodell]
)
]


== Unity Anwendung
\
#mytext[
- Assets
- Scripts
]


= Demo


= Herausforderungen und Ausblick
== Herausforderungen und Ausblick
\
#mytext[
- API-Ratenbegrenzung und Datenbereinigung
- Marker-Performance und Unübersichtlichkeit
- Zeitseriendaten und Visualisierung
- Abdeckung der ADS-B Daten
]

= Vielen Dank für Ihre Aufmerksamkeit!