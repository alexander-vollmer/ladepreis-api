#!/usr/bin/env python3
"""Find available charging stations without third-party dependencies."""

import json
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


BASE_URL = "https://ladepreis.app/api/v1"


def main() -> None:
    query = urlencode(
        {
            "city": "Hamm",
            "only_available": "true",
            "min_power_kw": 50,
            "limit": 10,
        }
    )
    request = Request(
        f"{BASE_URL}/stations?{query}",
        headers={"Accept": "application/json", "User-Agent": "ladepreis-api-example/1.0"},
    )

    try:
        with urlopen(request, timeout=15) as response:
            data = json.load(response)
    except HTTPError as error:
        retry_after = error.headers.get("Retry-After")
        hint = f"; retry after {retry_after}s" if retry_after else ""
        raise SystemExit(f"API returned HTTP {error.code}{hint}") from error
    except URLError as error:
        raise SystemExit(f"Request failed: {error.reason}") from error

    for station in data["items"]:
        address = station["address"]
        print(f"{station['name']} — {address['postal_code']} {address['city']}")
        for point in station["charging_points"]:
            if point["status"] != "available":
                continue
            price = point["pricing"]["adhoc_price_gross_eur_per_kwh"]
            price_text = f"{price:.2f} EUR/kWh" if price is not None else "price unknown"
            print(f"  {point['evse_id']}: {price_text}")


if __name__ == "__main__":
    main()

