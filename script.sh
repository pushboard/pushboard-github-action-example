#!/bin/sh

# Trip count
clickhouse-local \
-q "SELECT count(*) y1__num_trips
FROM file('data/green_tripdata/*', 'Parquet') 
FORMAT JSON 
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Total Trips"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/4oi8rehmn3/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Total trip distance
clickhouse-local \
-q "SELECT floor(sum(trip_distance), 2) y1__total_distance
FROM file('data/green_tripdata/*', 'Parquet')
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Total Distance"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/87r5ilczxx/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Total fare amount
clickhouse-local \
-q "SELECT floor(sum(fare_amount), 2) y1__total_fare_amount
FROM file('data/green_tripdata/*', 'Parquet')
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Total Revenue"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/d7jnqwthvw/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Number of trips by month
clickhouse-local \
-q "select toMonth(lpep_pickup_datetime) x__month, count(*) y1__num_trips 
from file('data/green_tripdata/*', 'Parquet')
group by x__month order by x__month 
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "# of Trips by Month"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/yi49iogxde/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Number of trips by hour
clickhouse-local \
-q "select toHour(lpep_pickup_datetime) x__hour, count(*) y1__num_trips 
from file('data/green_tripdata/*', 'Parquet')
group by x__hour order by x__hour 
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "# of Trips by hour"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/nweicscisp/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Number of trips by pickup location
clickhouse-local \
-q "select PULocationID x__PULocation, count(*) y1__num_trips 
from file('data/green_tripdata/*', 'Parquet')
group by x__PULocation order by y1__num_trips desc
limit 10
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Top 10 pick up locations"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/gostv9st73/' \
  --header 'Content-Type: application/json' \
  --data-binary @-