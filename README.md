VeganMelb
=========

Source code for https://veganmelbourne.com.au

## Adding new data

Add to the appopriate `CSV` in `data/`, then run :

    bundle exec ruby compile.rb

For places, put the directly into `public/static/places.json` without location,
and the next compile will geocode it.

Map icons from https://mapicons.mapsmarker.com/

## Running locally

    bin/dev
    # Visit http://localhost:3000

## Publishing

Ensure AWS credentials are in `.env`, then:

    bin/publish
