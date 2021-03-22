# Raumbelegung

## Einführung
Dieser Bericht zeigt, welche schritte für die Implementierung des Use Cases "Raumbelegung" geplant ist bzw. implementiert wurde.

## Vorgehensweise mit aktuellem Status:

- 1a. Anwendung Personenerkennung  (fertig)
- 1b. Personenerkennung  API (fertig)
- 2a. Erstellung eines Servers mit Knime Analytics Plattform  zu Automatisierung der Knime Workflows (ausstehend)
- 2b. Erstellung eines Skripts zu automatisierten Datenaufbereitung (ausstehend)
- 2c. Erstellung eines Skripts zu automatisierten starten der Knime Workflow für die Generierung der Prognose (ausstehend)
- 2d. Erstellung eines Skripts das die Prognose in den Raspi Webserver kopiert (ausstehend)
- 3d. Anwendung KILAB Webserver das die Prognose in einem Diagramm veranschaulicht (fertig)

### 1. Anwendung Personenerkennung und Personenabfrage-API
Für den schnellen Start der Personenzählung und der Personenabfrage-API ist auf dem KILAB Raspberry Pi unter /home/pi folgender Script hinterlegt:
https://github.com/cdeck3r/KILab/blob/master/Besucher%20z%C3%A4hlen%20%26%20Prognose%20bereitstellen/Raspberry%20Pi/StartCoralPersonenz%C3%A4hler.sh

Dieser kann auch als Autostart Script verwendet werden.


### 2. Server mit Knime Analytics Plattform 

Starte Knime Workflow in Batch Mode:
https://forum.knime.com/t/execute-workflow-in-batch-mode-windows-10/13986/2

### 3. KILAB Webserver mit Prognose
Für den schnellen Start des KILAB Webservers  ist auf dem KILAB Raspberry Pi unter /home/pi folgender Script hinterlegt:
https://github.com/cdeck3r/KILab/blob/master/Besucher%20z%C3%A4hlen%20%26%20Prognose%20bereitstellen/Raspberry%20Pi/StartWebserver.sh

Dieser kann auch als Autostart Script verwendet werden.
