#!/usr/bin/env bash
i=1; for j in *.jpg; do mv "$j" "$i.jpg" ;(( i++ )); done