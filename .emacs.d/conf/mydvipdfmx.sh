#!/bin/sh

dvipdfmx $1
rm ${1%dvi}.log
rm $1.dvi
rm $1.aux

echo "DELETE:" "${1%dvi}.log" "$1.dvi" "$1.aux"
