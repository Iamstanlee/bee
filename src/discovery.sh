#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

dir=~/recon/$1

function echoTask {
 echo "${green}__________$1__________${reset}"
}

function doGF {
 	if [ ! -d $dir/gf ];then
 		mkdir $dir/gf
 	fi
 	for pattern in $(gf -list);do
	gf $pattern $1 | sort -u > $dir/gf/$pattern.txt;
	done
}

if [ "$2" = "-s" ]; then
	if [ ! -d $dir ]; then
		mkdir $dir;
	fi
	echo $1 > $dir/domains.txt

	# get all urls
	echoTask "Getting All Urls"
	echo $1  | gau -o $dir/tmp.txt 2> err.txt;
	# echo $1 | waybackurls >> $dir/tmp.txt;
	cat $dir/tmp.txt | sort -u > $dir/urls.txt;rm $dir/tmp.txt;

	# extract js files
	echoTask "Extracting Js Files"
	cat $dir/urls.txt | grep -P "\w+\.js(\?|$)" > $dir/js.txt

	# run secretfinder against js files
	echoTask "Running Secretfinder Against Js Files"
	cat $dir/js.txt | xargs -P 20 -I %% bash -c 'secretFinder.py -i %% -o cli' 2> /dev/null >> $dir/secrets.txt

	# look for potentials urls via gf
	echoTask "Checking Urls Against GF-Patterns"
    doGF $dir/urls.txt;

    # fuzz/ directory search
	echoTask "Fuzzing For Juicy Files And Directories"
	for domain in $(cat $dir/domains.txt);do
	ffuf -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "https://$1/FUZZ" -w ~/wordlists/directory.txt -s -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -o $dir/fuzz.tmp
	cat $dir/fuzz.tmp | jq '[.results[]|{url: .url, status: .status, length: .length}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> $dir/fuzz.txt;
	rm $dir/fuzz.tmp;
	done;

else 
	# format domains
	# echo "https://$1" > $dir/domains.txt
	cat $dir/httpxdomains.txt | grep -E "200|204|301|302|403" | cut -d [ -f "1" | sort -u > $dir/domains.txt

	# # get all urls
	echoTask "Getting All Urls"
	# cat $dir/domains.txt  | gau -o $dir/tmp.txt;
	cat $dir/domains.txt | xargs -P 20 -I %% bash -c 'gau %%' 2> /dev/null >> $dir/tmp.txt

	# cat $dir/domains.txt | waybackurls >> $dir/tmp.txt;
	cat $dir/tmp.txt | sort -u > $dir/urls.txt;rm $dir/tmp.txt;
	

	# extract js files
	echoTask "Extracting Js Files"
	cat $dir/urls.txt | grep -P "\w+\.js(\?|$)" > $dir/js.txt
    
    # run secretfinder against js files
	echoTask "Running Secretfinder Against Js Files"
	cat $dir/js.txt | xargs -P 20 -I %% bash -c 'secretFinder.py -i %% -o cli' 2> /dev/null >> $dir/secrets.txt;

	# look for potentials urls via gf
	echoTask "Checking Urls Against GF-Patterns";
    doGF $dir/urls.txt;

    # fuzz/ directory search
	echoTask "Fuzzing For Juicy Files And Directories"
	i=0
	domain_count=`cat $dir/domains.txt | wc -l`
	for domain in $(cat $dir/domains.txt);do
	let "i+=1"
	echo -ne "current: $domain [ $i / $domain_count ] \\r"
	echo "__________ $domain __________" >> $dir/fuzz.txt
	d=`echo $domain | cut -d / -f "3"`
	ffuf -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "https://$d/FUZZ" -w ~/wordlists/directory.txt -s -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -o $dir/fuzz.tmp
	cat $dir/fuzz.tmp | jq '[.results[]|{url: .url, status: .status, length: .length}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> $dir/fuzz.txt;
	rm $dir/fuzz.tmp;
	done;

fi
