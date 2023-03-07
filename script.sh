#!/bin/sh

# Trip Count
echo $1 |
jq '. + {"title": "Total Trips"}' |
curl \
  --request POST 'https://pushboard.io/api/carddata/4oi8rehmn3/' \
  --header 'Content-Type: application/json' \
  --data-binary @-
