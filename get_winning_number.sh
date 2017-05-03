#!/bin/bash
MAX_PAGE=7
INDV_NUM_REPLACE="ball/"
OPTION_TAG_DATE_REPLACE="</option>"
COMMA=','
DASH='-'
BACKSLASH='/'
rm -f ./date.txt;
echo "Date,n1,n2,n3,n4,n5,n6" > date.txt;
BASE_URL_STR="http://vietlott.vn/vi/trung-thuong/ket-qua-trung-thuong/mega-6-45/winning-numbers/?p=1"
BASE_RESULT_URL_STR="http://vietlott.vn/vi/trung-thuong/ket-qua-trung-thuong/mega-6-45/?dayPrize="
URL_STR=$BASE_URL_STR;
echo $URL_STR;
curl -s $URL_STR | grep -o "[0-9]\{2\}-[0-9]\{2\}-[0-9]\{4\}</option>" | while read -r line ; do
    ROLL_DATE="${line/$OPTION_TAG_DATE_REPLACE/}";
    ROLL_DATE="${ROLL_DATE//$DASH/$BACKSLASH}";
    echo $ROLL_DATE;
    NO_OF_NUM=0;
    WINNING_RESULT_URL=$BASE_RESULT_URL_STR$ROLL_DATE
    curl -s $WINNING_RESULT_URL | grep -o "ball/[0-9]\{2\}" | while read -r xline ; do
	INDV_NUM="${xline/$INDV_NUM_REPLACE/$COMMA}";
	ROLL_DATE+=$INDV_NUM;
	NO_OF_NUM=$((NO_OF_NUM+1));
	if [ $NO_OF_NUM -eq 6 ]	
	then
	    echo $ROLL_DATE >> ./date.txt;
	    echo $ROLL_DATE;
	fi;	    
    done;
done;
