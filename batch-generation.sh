#!/usr/bin/env bash

(tail -n +2 "$1"; echo) | \
    while IFS=, read -r NAME TITLE EMAIL PHONE MATRIX; 
    do make print NAME="$NAME" \
                  TITLE="$TITLE" \
                  EMAIL="$EMAIL" \
                  PHONE="$PHONE" \
                  MATRIX="$MATRIX";
    done
