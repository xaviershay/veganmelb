VeganMelb
=========

Source code for https://veganmelbourne.com.au

## Adding new data

Add to the appopriate `CSV` in `data/`, then run:

    bin/compile

For places, put the directly into `public/static/places.json` without location,
and the next compile will geocode it. A Google Geocoder API key will need to be
placed in a `google-api-key` file.

Map icons from https://mapicons.mapsmarker.com/

## Running locally

    bin/dev
    # Visit http://localhost:3000

## Publishing

Ensure AWS credentials are in `.env`, then:

    bin/publish

`.env` should look like the following, with credentials that can be generated
frmo IAM Users in AWS Console:

    AWS_ACCESS_KEY_ID=somekey
    AWS_SECRET_ACCESS_KEY=arst
