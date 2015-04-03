#!/bin/sh
curl $1 -o /tmp/file_temp.jpg >/dev/null 2&>/dev/null 
./detectFaces /tmp/file_temp.jpg
rm /tmp/file_temp.jpg
