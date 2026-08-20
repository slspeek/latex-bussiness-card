#!/usr/bin/env bash

(tail -n +2 "$1"; echo) | \
    while IFS=$'\t' read -r NAME TITLE EMAIL PHONE MATRIX; 
    do make viewpdf NAME="$NAME" \
                    TITLE="$TITLE" \
                    EMAIL="$EMAIL" \
                    PHONE="$PHONE" \
                    MATRIX="$MATRIX";
    done
