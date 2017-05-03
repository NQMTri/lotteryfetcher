#!/bin/bash
####################
#GLOBAL VARIABLES
####################
MAX_PAGE=7
INDV_NUM_REPLACE="ball/"
OPTION_TAG_DATE_REPLACE="</option>"
COMMA=','
DASH='-'
BACKSLASH='/'
HEADER_TAG_OPEN="<b>"
HEADER_TAG_CLOSE="</b>"
BASE_URL_STR="http://vietlott.vn/vi/trung-thuong/ket-qua-trung-thuong/mega-6-45/winning-numbers/?p=1"
BASE_RESULT_URL_STR="http://vietlott.vn/vi/trung-thuong/ket-qua-trung-thuong/mega-6-45/?dayPrize="

# Prepare result file.
rm -f ./date.csv;
echo "Date,prize,n1,n2,n3,n4,n5,n6" > date.csv
# Main loop -> Read all possible dates in dropdown list.
curl -s $BASE_URL_STR | grep -o "[0-9]\{2\}-[0-9]\{2\}-[0-9]\{4\}</option>" | while read -r line ; do
#   Extract the rolling dates from the result
    ROLL_DATE="${line/$OPTION_TAG_DATE_REPLACE/}";
    ROLL_DATE="${ROLL_DATE//$DASH/$BACKSLASH}";
    # Create string to specific date using rolldate.
    WINNING_RESULT_URL=$BASE_RESULT_URL_STR$ROLL_DATE
    # Extract the prize amount
    PRIZE_AMOUNT="$(curl -s $WINNING_RESULT_URL | grep -o "<b>.*đồng</b>")"
    PRIZE_AMOUNT="${PRIZE_AMOUNT/$HEADER_TAG_OPEN/$COMMA}"
    PRIZE_AMOUNT="${PRIZE_AMOUNT/$HEADER_TAG_CLOSE/}"
    # Create the result string.
    ROLL_DATE=$ROLL_DATE$PRIZE_AMOUNT;
    NO_OF_NUM=0;
    # Loop of each date to extract winning numbers
    curl -s $WINNING_RESULT_URL | grep -o "ball/[0-9]\{2\}" | while read -r xline ; do
	INDV_NUM="${xline/$INDV_NUM_REPLACE/$COMMA}";
	ROLL_DATE+=$INDV_NUM;
	NO_OF_NUM=$((NO_OF_NUM+1));
	# If get enough number, print result to file.
	if [ $NO_OF_NUM -eq 6 ]	
	then
	    echo $ROLL_DATE >> ./date.csv;
	    echo $ROLL_DATE;
	fi;	    
    done;
done;
echo "Job Done! Finished extracting!";
