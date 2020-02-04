#!/bin/bash
# split.sh - by ChillerDragon
# splits teeworlds logfiles into smaller chunks
# and adds proper timestamps to all of the files

MAX_LINES=100000
LOGFILE=invalid.txt
FILE_EXTENSION=txt
BASENAME=sample_srv_

mkdir -p /tmp/tw_split || exit 1

if [ "$#" == "1" ]
then
    LOGFILE="$1"
elif [ "$#" == "2" ]
then
    LOGFILE="$1"
    MAX_LINES="$2"
    if [[ ! $MAX_LINES =~ ^[0-9]*$ ]]
    then
        echo "Error: MAX_LINES has to be numeric!"
        echo "       '$MAX_LINES' is not a number!"
        exit 1
    fi
else
    echo "usage: $(basename "$0") <tw logfile> [MAX_LINES]"
    exit 1
fi

if [ ! -f "$LOGFILE" ]
then
    echo "invalid logfile."
    exit 1
fi

year="$(date +'%Y')"
FILE_EXTENSION="${LOGFILE##*.}"
FILE_TS="${LOGFILE##*$year}"
FILE_TS="$year${FILE_TS%.*}"

mkdir -p "$FILE_TS" || exit 1

mv "$LOGFILE" "$FILE_TS" || exit 1
cd "$FILE_TS" || exit 1

BACKUP="/tmp/tw_split/$LOGFILE.bak"
cp "$LOGFILE" "$BACKUP"
BASENAME="${LOGFILE%$year*}"

split -d -l "$MAX_LINES" "$LOGFILE"

for log in x*
do
    echo "logfile: $log"
    first_line="$(head -n1 "$log")"
    if [[ "$first_line" =~ ^\[(.*)\]\[ ]]
    then
        ts_raw="${BASH_REMATCH[1]}"
        ts="$(echo "$ts_raw" | sed 's/:/-/g' | sed 's/ /_/g')"
        mv "$log" "${BASENAME}${ts}.${FILE_EXTENSION}"
    else
        echo "Could not parse teeworlds time stamp"
        exit 1
    fi
done

echo "finished!"
echo "replaced file '$LOGFILE'"
echo "with the folder '$FILE_TS'"
echo "original file was moved to '$BACKUP'"

