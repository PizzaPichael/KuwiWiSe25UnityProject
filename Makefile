.PHONY: diagrams
diagrams:
	java -jar docu/diagrams/jar/plantuml-mit-1.2025.10.jar docu/diagrams/models/models.puml --output-dir ../../assets
	java -jar docu/diagrams/jar/plantuml-mit-1.2025.10.jar docu/diagrams/models/slides-models.puml --output-dir ../../../presentation/assets