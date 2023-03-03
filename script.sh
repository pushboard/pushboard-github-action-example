#!/bin/sh

# Trip Count
~/clickhouse local \
-q "SELECT count(*) y1__num_trips
FOM file('green_tripdata/*', 'Parquet') 
FORMAT JSON 
SETTINGS input_format_parquet_skip_columns_with_unsupported_types_in_schema_inference = True" |
curl \
  --request POST 'https://pushboard.io/api/carddata/4oi8rehmn3/' \
  --header 'Content-Type: application/json' \
  --data-binary @-