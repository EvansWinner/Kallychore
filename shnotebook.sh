#!/usr/bin/env bash

bqstart() { 
    echo ,---------
}
export -f bqstart
bqend() { 
    echo \`---------
}
export -f bqend

if [ "$1" = "" ]; then
    echo "Use: $0 file"

## For any line not starting with a comment character (which will be
## code in the final product) escape any existing double-quote
## characters in the line, then add "echo -E" and double-quote before
## the line, then add a double quote after the line. Next remove the
## first comment character from any line beginning with a comment
## character.
else
    cat $1 |
    sed '/^#/! s/\"/\\\"/g' |	# Escape double-quotes
#    sed '/^#/! s/\`/\\\`/g' |
#    sed "/^#/! s/\#/\\\#/g" |
#    sed '/^#/! s/(/\\(/g' |
#    sed '/^#/! s/)/\\)/g' |
    sed '/^#/! s/^/echo -E "/g' | # Add echo commands to non-commented lines
    sed '/^#/! s/$/"/g' |	  # Add trailing double-quotes
    sed "s/^#//g" |
   bash
fi

