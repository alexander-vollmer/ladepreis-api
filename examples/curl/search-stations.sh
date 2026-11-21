#!/usr/bin/env sh
set -eu

curl --fail --show-error --silent --get \
  'https://ladepreis.app/api/v1/stations' \
  --data-urlencode 'city=Hamm' \
  --data-urlencode 'only_available=true' \
  --data-urlencode 'min_power_kw=50' \
  --data-urlencode 'limit=10'

