const baseUrl = "https://ladepreis.app/api/v1";
const params = new URLSearchParams({
  city: "Hamm",
  only_available: "true",
  min_power_kw: "50",
  limit: "10",
});

const response = await fetch(`${baseUrl}/stations?${params}`, {
  headers: { Accept: "application/json" },
  signal: AbortSignal.timeout(15_000),
});

if (!response.ok) {
  const retryAfter = response.headers.get("retry-after");
  const hint = retryAfter ? `; retry after ${retryAfter}s` : "";
  throw new Error(`ladepreis.app returned HTTP ${response.status}${hint}`);
}

const data = await response.json();
for (const station of data.items) {
  console.log(`${station.name} — ${station.address.postal_code} ${station.address.city}`);
  for (const point of station.charging_points) {
    if (point.status === "available") {
      const price = point.pricing.adhoc_price_gross_eur_per_kwh;
      console.log(`  ${point.evse_id}: ${price ?? "price unknown"}`);
    }
  }
}

