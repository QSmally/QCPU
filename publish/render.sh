#!/bin/sh

set -e
cd /Content

quarto render --to html
cp -Tr _site /usr/share/nginx/html
cp -Tr snippets /usr/share/nginx/html/snippets
