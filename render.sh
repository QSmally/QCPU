#!/bin/sh

cd /Content
quarto render --to html
cp -Tr _site /usr/share/nginx/html
