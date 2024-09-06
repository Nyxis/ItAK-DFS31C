#!/bin/bash

mkdir image;

find . -type f -name "*.jpeg" -exec mv {} "./image" \;