#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "USAGE: format_itol_svg.sh [MODE] [SVG_FILE] [KEYWORD_FILE]"
    echo ""
    echo "MODE          'italicize' or 'add_type_strain_t' (without quotes)"
    echo "SVG_FILE      the SVG file"
    echo "KEYWORD_FILE  one keyword per line, each keyword (if present in SVG) will be augmented in the SVG"
    echo ""
    echo "Script produces new outfile ending with '.out.svg'"
    echo ""
    echo "ABOUT: scans SVG file for keywords and applies formatting"
    exit 1
fi

MODE=$1
SVG_FILE=$2
OUTFILE="${SVG_FILE}.out.svg"
KEYWORD_FILE=$3

if  [[ $MODE == "italicize" ]]; then
	echo "Add italics to keywords ..."
elif [[ $MODE == "add_type_strain_t" ]]; then
	echo "Add superscript type strain at the end of keywords ..."
else
	echo "Error: unknown mode $MODE"
	exit 3
fi

cp $SVG_FILE $OUTFILE

while read line
do
  [[ "$line" =~ ^#.*$ ]] && continue # skipping comment lines
  [[ "$line" =~ ^$ ]] && continue # skipping empty lines

  KEYWORD=`printf "%s\n" "$line"`
  
  # working, but not needed, using sed directly
  # PATTERN="<text [^>]*>Sulfolobus solfataricus[^<]*</text>"

	if  [[ $MODE == "italicize" ]]; then
		RANDOM_NUM=$(( ( RANDOM % 10000 )  + 1 ))
  	ADD_ITALICS="<tspan style=\"font-style:italic\" id=\"tspan$RANDOM_NUM\">$KEYWORD<\/tspan>"
    sed -i "s/$KEYWORD/$ADD_ITALICS/g" $OUTFILE
	elif [[ $MODE == "add_type_strain_t" ]]; then
  	RANDOM_NUM=$(( ( RANDOM % 10000 )  + 1 ))
	  INSERT_UPCASE_T="<tspan style=\"font-size:65%;baseline-shift:super\" id=\"tspan$RANDOM_NUM\">T<\/tspan>"
    sed -i "s/$KEYWORD/$KEYWORD$INSERT_UPCASE_T/g" $OUTFILE
	else
		echo "Error: unknown mode $MODE"
		exit 3
	fi

done < "$KEYWORD_FILE"
