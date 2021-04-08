#!/bin/bash

# ###################################
# Bereso
# BEst REcipe SOftware
# ###################################
# BeReSo OCR Agent
# Version 1.5
# ###################################


# Config - example - variables set via Docker environment variables 
#BERESO_URL="http://bereso/" # URL to the BeReSo installation
#BERESO_PASSWORD="PASSWORD_FOR_OCR_AGENT" # Password for the OCR agent
#LANGUAGE=deu # Set tesseract processing language

export TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata/ # Tesseract tessdata folder

LOGPATH=/bereso_agent_ocr/bereso_agent_ocr.log
OCRTEMP=/bereso_agent_ocr/temp/

############################################
# NO CONFIG CHANGE NEEDED BELOW THIS LINE
############################################

# Log start date and time
echo $'' >> $LOGPATH
start=$(date '+%d/%m/%Y %H:%M:%S');
echo "$start starting..." >> $LOGPATH
echo "$start starting..."

# delete old temp ocr path and create new one
rm -r $OCRTEMP
mkdir $OCRTEMP

# Get list with URLs and item ids
OCRLIST=$(curl "$BERESO_URL?module=agent_ocr&action=list&ocr_password=$BERESO_PASSWORD")

# seperate OCRLIST into an array per line
readarray -t OCRITEM <<<"$OCRLIST"

# loop through all items
for i in ${OCRITEM[@]}; do
        # split the item via , into item_id and image_url
        IFS=',' # split by comma
        read -a OCRITEMSPLIT <<< "$i"
        OCRITEMID="${OCRITEMSPLIT[0]}"
        OCRITEMURL="${OCRITEMSPLIT[1]}"

        # load the image
        curl -o image $OCRITEMURL > /dev/null

        # optimize and convert (input is png or jpg)
        convert image -colorspace Gray -units pixelsperinch -density 300 -depth 8 imageoptimized > /dev/null

        # start OCR using tesseract
        tesseract -l $LANGUAGE imageoptimized ocr > /dev/null # start ocr with language $LANGUAGE and save the output in ocr.txt

        cat ocr.txt >> $OCRTEMP$OCRITEMID

        # delete the temp files
        rm image
        rm imageoptimized
        rm ocr.txt
done

# Upload the files
for file in $OCRTEMP*
do
        # Basefile is filename and item id
        BASEFILE=`basename $file`

        # build save ocr url
        OCRSAVEURL="$BERESO_URL?module=agent_ocr&action=save&ocr_password=$BERESO_PASSWORD&item=$BASEFILE"

        OCRTEXT=$OCRTEMP$BASEFILE # path to ocr text file

        # if $BASEFILE is not a number but * -> there is no file in temp
        if [ "$BASEFILE" == "*" ]
        then
                echo "No ocr job" >> $LOGPATH # Log nothing todo
        else
                LOGUPLOAD=$(curl -F "ocr_text_file=@$OCRTEXT" $OCRSAVEURL)  # upload the textfile for this entry 
                echo $LOGUPLOAD >> $LOGPATH # save response in logfile
                echo $LOGUPLOAD
        fi

done


# Log end date and time
end=$(date '+%d/%m/%Y %H:%M:%S');
echo "$end finished" >> $LOGPATH
echo "$end finished"
