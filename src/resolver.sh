#!/bin/sh
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

dir=~/recon/$1
if [ ! -d $dir]; then
		mkdir $dir;
fi
sublist3r.py -d $1 -o $dir/subs.txt;
subfinder -d $1 -silent | grep $1 >> $dir/subs.txt;
assetfinder --subs-only $1 >> $dir/subs.txt;
cat $dir/subs.txt | sort -u > $dir/subdomains.txt;rm $dir/subs.txt;
# filter live domains
echo "${green}__________Checking For Live Domains__________${reset}"
cat $dir/subdomains.txt | httpx -follow-redirects  -title -status-code --follow-host-redirects -threads 300 -silent -o $dir/httpxdomains.txt;
# scan for potential takeovers
echo "${green}__________Checking For Potential Subdomain Takeover__________${reset}"
subjack -w $dir/subdomains.txt -t 100 -timeout 30 -a -o -ssl $dir/toTakover.txt;

# fix issue with subover providers.json file
# echo "Results from subover -->" >> $dir/toTakover.txt;
# subover -l $dir/subdomains.txt -a | grep -E "Found|Takeover" >> $dir/toTakover.txt;
# subover -l $dir/subdomains.txt -a | tee -a $dir/toTakover.txt;