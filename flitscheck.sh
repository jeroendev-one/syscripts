#!/bin/bash
DATE=$(date "+%a, %b %d")
ROAD1="A1"
ROAD2="A35"
RECIEVER=""
TITLE="Road report for $DATE"
APP_TOKEN=""
USER_TOKEN=""

FLITS_CHECK=$(curl -s https://tesla.flitsmeister.nl/teslaFeed.json | jq '.features[] | select (.properties.road == "'$ROAD1'" or .properties.road == "'$ROAD2'") | select (.properties.type_description != null) | {Weg: .properties.road, Richting: .properties.direction, Soort: .properties.type_description}'  | sed 's/[{,}"]/ /g' | sed 's/stationaryvehicle/Stilstaand voertuig/g; s/speedtrap/Flitser/g' > flits.json)

CHECK=$(cat flits.json | uniq)

if [ ! -z "$CHECK" ]; then

    MESSAGE=$(echo -e "Er zijn controles / opmerkelijkheden op je route: \n $CHECK")

else

    MESSAGE=$(echo "Er zijn geen controles / opmerkelijkheden op je route.")

fi

wget https://api.pushover.net/1/messages.json --post-data="token=$APP_TOKEN&user=$USER_TOKEN&message=$MESSAGE&title=$TITLE" -qO- > /dev/null 2>&1 &

rm -f flits.json
