#import "@preview/vienna-tech:1.0.0": *
#import "@preview/wordometer:0.1.4": total-words, word-count

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

#show "Typst": fancy-typst
#show "LaTeX": fancy-latex

// Using the configuration
#show: tuw-thesis.with(
  header-title: "Kulturwissenschaft/en",
)

#maketitle(
  title: [Visualiszing private plane travel],
  thesis-type: [Kulturwissenschaft/en],
  authors: (
    (
      name: "Michael Kaup",
      email: "michael.kaup@student.htw-berlin.de",
      matrnr: "s0589545",
    ),
    (
      name: "David Kirchner",
      email: "david.kirchner@student.htw-berlin.de",
      matrnr: "s0589227",
    ),
  ),
)

#pagebreak()

#outline()

#pagebreak()


#include "01_Einleitung/01_Einleitung.typ"

#include "02_Systemanforderungen/02_Systemanforderungen.typ"

#include "03_Verwendete_Assets/03_Verwendete_Assets.typ"

#include "04_Interaktion/04_Interaktion.typ"

#include "05_Design_der_Benutzeroberflaechen/05_Design_der_Benutzeroberflaechen.typ"

#include "06_Technische_Dokumentation/06_Technische_Dokumentation.typ"

#include "07_Problemlösung/07_Problemlösung.typ"

#include "08_Fazit/08_Fazit.typ"

#bibliography("09_Bibliography/09_Bibliography.bib")
