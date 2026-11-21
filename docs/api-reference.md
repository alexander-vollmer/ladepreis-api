# API-Referenz

Basis-URL: `https://ladepreis.app/api/v1`

Alle Datenendpunkte liefern JSON und sind ohne Anmeldung oder API-Schlüssel lesbar. Die maschinenlesbare, jeweils aktuelle Spezifikation liegt unter <https://ladepreis.app/openapi.json>.

## `GET /stations`

Sucht Ladestandorte. Ohne Ortsfilter liefert der Endpunkt einen paginierten Ausschnitt des Datenbestands.

### Suchparameter

| Parameter | Typ | Standard | Beschreibung |
|---|---:|---:|---|
| `lat` | Zahl | – | Breitengrad von -90 bis 90; nur gemeinsam mit `lon` |
| `lon` | Zahl | – | Längengrad von -180 bis 180; nur gemeinsam mit `lat` |
| `radius_km` | Zahl | `10` | Radius von 0,1 bis 200 km |
| `min_lat`, `max_lat` | Zahl | – | Grenzen einer Bounding-Box; alle vier Boxwerte sind erforderlich |
| `min_lon`, `max_lon` | Zahl | – | Grenzen einer Bounding-Box; alle vier Boxwerte sind erforderlich |
| `city` | Text | – | Teil eines Ortsnamens |
| `postal_code` | Text | – | Genaue Postleitzahl |
| `only_adhoc` | Boolean | `false` | Nur Standorte mit gemeldeter Ad-hoc-Möglichkeit |
| `only_available` | Boolean | `false` | Nur Standorte mit mindestens einem als frei gemeldeten Ladepunkt |
| `min_power_kw` | Zahl | – | Mindestleistung eines passenden Ladepunkts, mindestens 0 |
| `max_price_kwh` | Zahl | – | Maximaler bestätigter Brutto-Ad-hoc-Preis in EUR/kWh |
| `limit` | Integer | `50` | 1 bis 500 Standorte |
| `offset` | Integer | `0` | Startposition, mindestens 0 |

Wenn mehrere Ladepunktfilter gesetzt sind, muss derselbe Ladepunkt alle Kriterien erfüllen. Die Antwort enthält danach alle Ladepunkte des passenden Standorts.

### Antwort

```json
{
  "count": 1,
  "has_more": false,
  "limit": 10,
  "offset": 0,
  "items": []
}
```

`count` ist die Anzahl auf der aktuellen Seite. Solange `has_more` wahr ist, kann die nächste Seite mit `offset + limit` geladen werden.

## `GET /stations/{station_id}`

Liefert einen Standort einschließlich Betreiber, Adresse, Koordinaten und zugeordneten Ladepunkten. `station_id` ist die numerische interne ID aus einer Stationsantwort.

## `GET /evse/{evse_id}`

Liefert technische Daten, Status, Preisangaben und den Standort eines Ladepunkts. Die EVSE-ID muss im URL-Pfad kodiert werden.

```text
GET /api/v1/evse/DE%2AABC%2AE12345%2A1
```

Die ID im Beispiel ist ein Platzhalter.

## `GET /geocode`

Sucht Orte, Gemeinden und PLZ-Gebiete in der lokalen Datenbank. Dies ist keine vollständige Straßenadresssuche.

| Parameter | Typ | Beschreibung |
|---|---:|---|
| `q` | Text | Pflichtfeld, mindestens 2 Zeichen |
| `limit` | Integer | 1 bis 20, Standard 6 |

Die Antwort enthält unter anderem `display_name`, `short_name`, `postal_code`, `lat`, `lon` und `station_count`.

## `GET /stats`

Liefert Kennzahlen wie `stations_total`, `stations_adhoc`, `charging_points_total`, `charging_points_with_price`, `charging_points_available` und `active_feeds`. Die Antwort kann kurzzeitig zwischengespeichert sein.

## `GET /sources`

Liefert die aktuell aktiven Quellen, Angebotslinks und Lizenzangaben. Quellenreferenzen am einzelnen Datensatz können getrennt für Standortdaten, Status und Tarif vorkommen.

## Wichtige Antwortfelder

### Standort

- `id`, `external_station_id`, `name`
- `source`
- `operator.id`, `operator.name`
- `address.street`, `house_number`, `postal_code`, `city`, `country`
- `coordinates.latitude`, `coordinates.longitude`
- `adhoc_charging_available`
- `payment_methods`, `authentication_methods`
- `summary.total_charging_points`, `summary.available_charging_points`
- `charging_points`
- `static_data_updated_at`
- `distance_meters` bei einer Umkreissuche

### Ladepunkt

- `evse_id`, `adhoc_available`
- `status`: `available`, `occupied`, `reserved`, `out_of_service` oder `unknown`
- `status_updated_at`, `status_source`
- `technical.max_power_kw`, `current_type`, `connectors`
- `pricing`

### Preise

- `currency`, `vat_status`, `gross_price_confirmed`
- `adhoc_price_gross_eur_per_kwh`, `raw_feed_price_eur_per_kwh`
- `adhoc_price_gross_eur_per_min`, `raw_feed_price_eur_per_min`
- `adhoc_session_fee_eur`, `raw_feed_session_fee_eur`
- `adhoc_blocking_fee_eur_per_min`, `adhoc_blocking_grace_period_min`
- `max_charging_duration_min`, `tariff_name`, `tariff_rules`, `tariff_updated_at`
- `source`

Ist der Umsatzsteuerstatus unbekannt, bleiben berechnete Bruttofelder `null`. Der unveränderte Quellwert kann weiterhin in einem `raw_feed_*`-Feld stehen.

## Kartenkacheln

```text
GET  https://ladepreis.app/tiles/{z}/{x}/{y}.png
HEAD https://ladepreis.app/tiles/{z}/{x}/{y}.png
```

`z` liegt zwischen 0 und 19, `x` und `y` sind nichtnegative ganze Zahlen. Bei einer Einbindung ist die Namensnennung der OpenStreetMap-Mitwirkenden erforderlich.

## Rate-Limit und Fehler

Das gemeinsame Limit der JSON-Endpunkte beträgt 60 Anfragen innerhalb von 60 Sekunden je IPv4-Adresse oder IPv6-/64-Netz. Bei HTTP 429 gibt `Retry-After` die Wartezeit in Sekunden an.

Clients sollten Netzwerkfehler, `404`, `422` und `429` behandeln, ein sinnvolles Timeout setzen und wiederholte Antworten kurz zwischenspeichern.

