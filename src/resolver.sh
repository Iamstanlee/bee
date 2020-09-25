#!/bin/sh
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

dir=~/recon/$1
if [ ! -d $dir ]; then
		mkdir $dir;
fi
function echoTask {
 echo "${green}[*] $1${reset}"
}
sublist3r.py -d $1 -o $dir/subs.txt;
subfinder -d $1 -silent | grep $1 >> $dir/subs.txt;
assetfinder --subs-only $1 >> $dir/subs.txt;
cat $dir/subs.txt | sort -u > $dir/subdomains.txt;rm $dir/subs.txt;
# filter live domains
echoTask "Checking For Live Domains"
cat $dir/subdomains.txt | httpx -follow-redirects  -title -status-code --follow-host-redirects -threads 300 -silent -o $dir/httpxdomains.txt;
# scan for potential takeovers
echoTask "Checking For Potential Subdomain Takeover"
# cat $dir/httpxdomains.txt | grep -E "404" | cut -d [ -f "1" | sort -u > $dir/tmp.txt;rm $dir/tmp.txt
subjack -w $dir/subdomains.txt -t 100 -timeout 30 -a -ssl -o $dir/toTakover.txt;

# fix issue with subover providers.json file
# echo "Results from subover -->" >> $dir/toTakover.txt;
# subover -l $dir/subdomains.txt -a | grep -E "Found|Takeover" >> $dir/toTakover.txt;
# subover -l $dir/subdomains.txt -a | tee -a $dir/toTakover.txt;