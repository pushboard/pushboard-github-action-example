#!/bin/sh

curl \
  --request POST 'https://pushboard.io/api/carddata/yi49iogxde/' \
  --header 'Content-Type: application/json' \
  --data-raw \
  '{
    "title": "# Taxi Trips",
    "type": "category",
    "x__month": [ 
      "Jan", "Feb", "Mar", "Apr", "May", "Jun" 
    ], 
    "y1__Yellow Taxi": [ 
      2463931, 2979431, 3627882, 3599920, 3588295, 3558124 
    ], 
    "y2__Green Taxi": [ 
      62495, 69399, 78537, 76136, 76891, 73718
    ]
  }'
