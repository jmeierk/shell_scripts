#!/bin/bash


if [ "$#" -ne 3 ]; then
cat << EOF
USAGE         svg_auto_formatter.sh  MODE  SVG_FILE  KEYWORD_FILE

ABOUT         This script is meant to fix otherwise laborious SVG
              postprocessing tasks in phylogenetic trees as e.g.
              produced by iTOL.

OUTPUT        produces new output file ending with '.modified.svg'

== COMMAND LINE OPTIONS ==

  MODE          I -> italicize keywords
                or
                T -> adds superscript 'T' to the end of the keyword
  SVG_FILE      the SVG file
  KEYWORD_FILE  one keyword per line, each keyword (if present in 
                SVG) will be augmented in the SVG
EOF

    exit 0
fi

MODE=$1
SVG_FILE=$2

if [ ! -f $SVG_FILE ]; then
    echo "ERROR: SVG file $SVG_FILE not found!"    
    exit 1 
fi

SVG_FILE=`readlink -e $SVG_FILE`
SVG_PATH=`dirname $SVG_FILE`

KEYWORD_FILE=$3
if [ ! -f $KEYWORD_FILE ]; then
    echo "ERROR: Keyword file $KEYWORD_FILE not found!"
    exit 2
fi

OUTFILE=$(basename "$SVG_FILE" .svg).modified.svg
OUTFILE=${SVG_PATH}/${OUTFILE}

if ! [ "${SVG_FILE##*.}" = "svg" ]; then
  echo "Error: please provide an SVG file! $SVG_FILE|" 
  exit 1
fi

if  [[ $MODE == "I" ]]; then
	echo "Adding italics to keywords if those exist in SVG file ..."
elif [[ $MODE == "T" ]]; then
	echo "Adding superscript 'T' to end of keywords if those exist in SVG file ..."
else
	echo "Error: unknown mode $MODE. Use either 'I' or 'T'!".
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

	if  [[ $MODE == "I" ]]; then
		RANDOM_NUM=$(( ( RANDOM % 10000 )  + 1 ))
  	ADD_ITALICS="<tspan style=\"font-style:italic\" id=\"tspan$RANDOM_NUM\">$KEYWORD<\/tspan>"
    sed -i "s/$KEYWORD/$ADD_ITALICS/g" $OUTFILE
	elif [[ $MODE == "T" ]]; then
  	RANDOM_NUM=$(( ( RANDOM % 10000 )  + 1 ))
	  INSERT_UPCASE_T="<tspan style=\"font-size:65%;baseline-shift:super\" id=\"tspan$RANDOM_NUM\">T<\/tspan>"
    sed -i "s/$KEYWORD/$KEYWORD$INSERT_UPCASE_T/g" $OUTFILE
	else
		echo "Error: unknown mode $MODE"
		exit 3
	fi

done < "$KEYWORD_FILE"

echo "Successfully wrote output file $OUTFILE."
