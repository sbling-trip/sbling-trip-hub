#!/bin/bash
# Check if at least one argument is provided
if [ "$1" = "" ]; then
  echo "Usage: $0 <image tag> [environment]"
  exit 1
fi

# exit when any command fails
set -e

docker build -t sblingtrip/sbling-trip-hub:"$1" .
docker stop sbling-trip-hub || true
while [ ! -z "$(docker ps -q -f name=sbling-trip-hub)" ]; do
    echo "Waiting for sbling-trip-hub to stop..."
    sleep 1
done
docker run -d -it --rm --privileged \
  --name sbling-trip-hub \
  -p 10022:22 \
  -p 9080:80 \
  -p 10443:443 \
  -p 15432:5432 \
  -v /Users/kimhyun/sbling_trip_volume/postgres_data_prod:/home/sbling/sbling-trip-db \
  sblingtrip/sbling-trip-hub:"$1"

