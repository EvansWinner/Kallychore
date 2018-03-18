#!/usr/bin/env bash

if [ "$1" = "" ]; then
    echo "Use: $0 file"
else
    cat $1 |
    sed '/^#/! s/\"/\\\"/g' |     # Escape double-quotes
    sed '/^#/! s/^/echo -E "/g' | # Add echo commands to non-commented lines
    sed '/^#/! s/$/"/g' |	  # Add trailing double-quotes
    sed "s/^#//g" |
    bash
fi

