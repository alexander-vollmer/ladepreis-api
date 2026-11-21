# Quellen- und Lizenzhinweise

ladepreis.app führt Informationen aus mehreren Datenquellen zusammen. Standortdaten, Verfügbarkeitsstatus und Tarifangaben können jeweils aus unterschiedlichen Quellen stammen und unterschiedlichen Bedingungen unterliegen.

Die aktuelle, maschinenlesbare Liste ist immer maßgeblich:

<https://ladepreis.app/api/v1/sources>

Zusätzlich liefert die API Quellenreferenzen direkt am Datensatz:

- `station.source` für Standort- und Ausstattungsdaten
- `charging_points[].status_source.source` für den Status
- `charging_points[].pricing.source` für Tarif- und Preisangaben

Eine Quellenreferenz kann unter anderem `provider_name`, `feed_title`, `offer_url`, `license`, `license_url`, `attribution`, `reuse_requirements` und `modification_notice` enthalten.

Bei CC BY 4.0 sind insbesondere die verlangte Namensnennung, ein Lizenzlink und ein Hinweis auf vorgenommene Änderungen zu beachten. Andere Quellen können abweichende Anforderungen haben. Dieses Repository ersetzt keine Prüfung der konkreten Lizenzbedingungen.

Die Hintergrundkarte basiert auf OpenStreetMap-Daten. Bei ihrer Verwendung ist die Namensnennung `© OpenStreetMap-Mitwirkende` erforderlich; die Datenbank steht unter der Open Database License 1.0. Weitere aktuelle Hinweise stehen auf <https://ladepreis.app/api>.

