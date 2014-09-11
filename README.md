VeganMelb
=========

Source code for http://veganmelbourne.com.au

## Adding new data

Add to the appopriate `CSV` in `data/`, then run :

    bundle exec ruby compile.rb

For places, put the directly into `public/static/places.json` without location,
and the next compile will geocode it.

Map icons from http://mapicons.nicolasmollet.com/

(The geocoder has been a bit screwy lately, so you may have to
check the generated files by hand.)

## Running locally

`shotgun` is an auto-reloading ruby server:

    gem install shotgun
    shotgun
    # Visit http://localhost:9393
