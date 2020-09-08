#!/bin/bash

dir=~/recon/$1

cat $dir/domains.txt | nuclei -c 200 -silent -t /usr/local/bin/nuclei-templates/ -o $dir/nuclei.txt