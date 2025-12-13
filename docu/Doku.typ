#import "@preview/vienna-tech:1.0.0": *
#import "@preview/wordometer:0.1.4": total-words, word-count

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

= Vorgaben

Im Folgenden einige Punkte, die ich für eine gute Dokumentation empfehle:

+ Einleitung: Hier wird eine kurze Beschreibung des Projekts gegeben und die Ziele der Dokumentation erläutert.

+ Systemanforderungen: Auflistung der technischen Anforderungen, die für das Projekt benötigt werden, z. B. die verwendete Unity-Version, die benötigte Hardware und die benötigte Software.

+ Verwendete Assets und Bibliotheken: Hier werden die verwendeten externen Assets und Bibliotheken beschrieben, einschließlich ihrer Funktionalität und ihres Beitrags zum Projekt.

+ Interaktion der Benutzenden: Hier wird beschrieben, wie die Benutzenden mit dem Projekt interagieren können, einschließlich der verwendeten Eingabegeräte.

+ Design der Benutzeroberflächen: Hier wird erklärt, wie das Design der Benutzeroberflächen entwickelt wurde, einschließlich der Verwendung von Farben, Schriften, Layouts und anderen Design-Elementen.

+ Technische Dokumentation: Hier werden technische Details des Projekts beschrieben, z. B. die verwendeten Skripte, die verwendeten Assets und die Implementierung von Features.

+ Problemlösung: Hier werden Probleme beschrieben, die bei der Entwicklung des Projekts aufgetreten sind und wie diese gelöst wurden.

+ Fazit: Hier werden die Ergebnisse des Projekts zusammengefasst und eine Aussicht gegeben, wie das Projekt fortgeführt werden könnte.


Natürlich könnt ihr auch eine andere Struktur verwenden, wenn diese für euer Projekt sinnvoll ist.
Verwendet gerne Screenshots von der Anwendung und Code an Stellen, an denen dies Sinn ergibt.
Von jeder Gruppe brauche ich nur eine Dokumentation. Jedes Mitglied soll erkennbar 5 Seiten (+-1)
schreiben und hervorheben, was er oder sie zum Projekt beigetragen hat. Mehr als 15 Seiten soll das
Dokument nicht umfassen.