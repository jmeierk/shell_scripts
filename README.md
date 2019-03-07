shell_scripts
=============

A collection of shell scripts that come in handy from time to time:

* svg_auto_formatter: script was originally designed to automatically change formatting of labels in phylogenetic trees as produced by the iTOL web service (https://itol.embl.de). The script can operate in two different modes: it reads a list of keywords from a text file and (1) replaces these keywords in the provided SVG file by an italicized version of that string or (2) add a T in superscript after the keyword (this is to identify type strains in prokaryotic taxonomy).

EXAMPLE: ./svg_auto_formatter.sh I example/example.svg example/keywords_to_format.txt

