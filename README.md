# ladepreis.app API

Offene REST-API für Ladepunkte, Ad-hoc-Preise und gemeldete Verfügbarkeiten in Deutschland.

- Basis-URL: `https://ladepreis.app/api/v1`
- Format: JSON über HTTPS
- Authentifizierung: keine
- Limit: 60 Anfragen je 60 Sekunden pro IPv4-Adresse oder IPv6-/64-Netz
- Interaktive Dokumentation: <https://ladepreis.app/api>
- OpenAPI 3.1: <https://ladepreis.app/openapi.json>

Die API wird aus einem serverseitigen Datenbestand bedient. Ein API-Aufruf löst keinen direkten Abruf bei einem Ladeinfrastrukturbetreiber aus.

## Schnellstart

```bash
curl --get 'https://ladepreis.app/api/v1/stations' \
  --data-urlencode 'city=Hamm' \
  --data-urlencode 'only_available=true' \
  --data-urlencode 'limit=10'
```

Eine Umkreissuche mit Preis- und Leistungsfilter:

```bash
curl --get 'https://ladepreis.app/api/v1/stations' \
  --data-urlencode 'lat=51.69685' \
  --data-urlencode 'lon=7.76306' \
  --data-urlencode 'radius_km=10' \
  --data-urlencode 'min_power_kw=50' \
  --data-urlencode 'max_price_kwh=0.59'
```

## Endpunkte

| Methode | Pfad | Zweck |
|---|---|---|
| `GET` | `/stations` | Standorte suchen und filtern |
| `GET` | `/stations/{station_id}` | Einen Standort abrufen |
| `GET` | `/evse/{evse_id}` | Einen Ladepunkt per EVSE-ID abrufen |
| `GET` | `/geocode?q=Hamm` | Orte und Postleitzahlen suchen |
| `GET` | `/stats` | Kennzahlen zum Datenbestand abrufen |
| `GET` | `/sources` | Aktuelle Datenquellen und Lizenzen abrufen |

Kartenkacheln sind zusätzlich unter `https://ladepreis.app/tiles/{z}/{x}/{y}.png` verfügbar. Details zu Parametern, Antworten, Fehlern und Datenfeldern stehen in der [API-Referenz](docs/api-reference.md).

## Beispiele

- [cURL](examples/curl/search-stations.sh)
- [Python (nur Standardbibliothek)](examples/python/search_stations.py)
- [JavaScript mit `fetch`](examples/javascript/search-stations.mjs)
- [Dart mit `HttpClient`](examples/dart/search_stations.dart)

Die Beispiele benötigen keinen API-Schlüssel. Sie verwenden Live-Daten; Inhalte und Trefferzahlen können sich ändern.

## Wichtige Datenhinweise

- `available` bedeutet, dass ein Ladepunkt zuletzt als frei gemeldet wurde. Das ist keine Reservierung oder Verfügbarkeitsgarantie.
- Ein fehlender Preis bedeutet nicht, dass das Laden kostenlos ist.
- Normalisierte Bruttopreise werden nur ausgegeben, wenn der Umsatzsteuerstatus bekannt ist. Der ursprüngliche Wert bleibt in `raw_feed_*` erhalten.
- Filter wie Verfügbarkeit, Mindestleistung und Höchstpreis müssen gemeinsam von mindestens einem Ladepunkt des Standorts erfüllt werden. Die Antwort enthält dennoch alle Ladepunkte dieses Standorts.
- Vor dem Laden gilt der am Ladepunkt oder im Bezahlvorgang angezeigte Tarif.

## Quellen und Lizenzen

Die Daten stammen aus mehreren Angeboten der Mobilithek und können unterschiedlichen Lizenzen unterliegen, unter anderem CC BY 4.0 und CC0 1.0. Die API liefert Quellenreferenzen direkt am Standort, Status und Tarif. Die aktuelle Liste steht unter:

```text
https://ladepreis.app/api/v1/sources
```

Wer Daten weiterverwendet, muss die Lizenz und die `reuse_requirements` der konkreten Quelle beachten. Kartendaten unterliegen gesonderten Bedingungen; siehe [Lizenzhinweise](docs/licensing.md).

## Fehler und Fair Use

- `404`: Standort oder EVSE-ID nicht gefunden
- `422`: ungültige oder unvollständige Parameter
- `429`: Anfragelimit erreicht; `Retry-After` beachten

Antworten sollten angemessen zwischengespeichert werden. Bitte keine unnötigen Polling-Schleifen verwenden.

## Repository

Dieses Repository dokumentiert die öffentliche API und enthält Client-Beispiele. Der Servercode und die Quelldaten sind nicht Bestandteil dieses Repositorys.

## Lizenz

Die selbst erstellten Inhalte dieses Repositorys – insbesondere Dokumentation und Beispielcode – stehen unter der [MIT-Lizenz](LICENSE).

Die MIT-Lizenz gilt **nicht** für Daten, die über die ladepreis.app API abgerufen werden, für Inhalte der jeweiligen Datenanbieter oder für Kartendaten. Für diese Inhalte gelten die jeweils in den API-Antworten, unter [`GET /api/v1/sources`](https://ladepreis.app/api/v1/sources) und in den [Quellen- und Lizenzhinweisen](docs/licensing.md) genannten Bedingungen.
