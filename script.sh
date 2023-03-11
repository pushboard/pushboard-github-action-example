#!/bin/sh

# Trip count
clickhouse-local \
-q "SELECT count(*) y1__num_trips
FROM file('data/green_tripdata/*', 'Parquet') 
where passenger_count >=1 
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
where passenger_count >=1 
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
where divide(fare_amount, trip_distance) > 1.5 and trip_distance > 0
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
where passenger_count >=1 and toMonth(lpep_pickup_datetime) <= 11
group by x__month order by x__month 
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "# Trips by month"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/yi49iogxde/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Number of trips by hour
clickhouse-local \
-q "select toHour(lpep_pickup_datetime) x__hour, count(*) y1__num_trips 
from file('data/green_tripdata/*', 'Parquet')
where passenger_count >=1 
group by x__hour order by x__hour 
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "# Trips by hour"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/nweicscisp/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Avg, mdn distance by hour
clickhouse-local \
-q "select toHour(lpep_pickup_datetime) x__hour, floor(avg(trip_distance),2)  y1__avg_distance,
floor(median(trip_distance),2)  y2__med_distance
from file('data/green_tripdata/*', 'Parquet')
where passenger_count >=1 
group by x__hour order by x__hour 
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Avg, mdn distance by hour"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/0axb9vs2j2/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Number of trips by pickup location
clickhouse-local \
-q "select PULocationID x__PULocation, count(*) y1__num_trips 
from file('data/green_tripdata/*', 'Parquet')
where passenger_count >=1 
group by x__PULocation order by y1__num_trips desc
limit 10
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Top 10 pick up locations"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/gostv9st73/' \
  --header 'Content-Type: application/json' \
  --data-binary @-


# Toll count
clickhouse-local \
-q "select if(total_amount >0, 'Toll', 'No Toll') as x__toll, count(*) as y1__count 
FROM file('data/green_tripdata/*', 'Parquet') 
where passenger_count >=1 
group by x__toll 
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Tolls vs No Tolls"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/3ayjjwlyrw/' \
  --header 'Content-Type: application/json' \
  --data-binary @-

# Tip count
clickhouse-local \
-q "select if(tip_amount >0, 'Tip', 'No Tip') as x__tip, count(*) as y1__count 
FROM file('data/green_tripdata/*', 'Parquet') 
where passenger_count >=1 
group by x__tip
FORMAT JSON
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
jq '. + {"title": "Tipping vs No Tipping"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/7uznfi6q9p/' \
  --header 'Content-Type: application/json' \
  --data-binary @-