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

if [ $2 = "-s" ]; then
	if [ ! -d $dir ]; then
		mkdir $dir;
	fi
	echo $1 > $dir/domains.txt

	# get all urls
	echoTask "Getting All Urls"
	echo $1
	echo $1  | gau -o $dir/tmp.txt 2> err.txt;
	# echo $1 | waybackurls >> $dir/tmp.txt;
	cat $dir/tmp.txt | sort -u > $dir/urls.txt;rm $dir/tmp.txt;


	# fuzz/ directory search
	echoTask "Fuzzing For Juicy Files And Directories"
	for domain in $(cat $dir/domains.txt);do
	ffuf -c -H "X-Aiven-Client-Version: aiven-console/3.2.0-1475.gfa4007f97e" -H "Authorization: aivenv1 zS7n14DGuWR8GXKlxu89U5GbgR0QDlFNCCMzhayMDCfNsxNmFSmkqziC1WBZYTU8DBZydgg2qkX10zf+dO0cHZprS1Gt4TXMjPrvySfCqZTEjvbifpOWC+PwCVzncS/Ij9p+QOjwVB05SkpSib24NwYEWBpdHlFYT8ybUP1UXvzx6pSSyVEFvLNbazBneXwsAWp5814NryoaaTLr1Qe8pv0tTXids99E4/AnKedVjfwvh0imnRS0grbD0ieNpzW9DKFnSTG6GXH81Wx3B2fWBkMaSTOxLzVDcxn6lZegNfqfKUhCkL74S/arERaI5vRJ4TDLRDiOzHW7Bwez9pIVq/tM0BowoQEiuTbRbOFjJbGnF81CpC1bfDg38mEjir6I" -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "https://$1/FUZZ" -w ~/wordlists/directory.txt -s -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -o $dir/fuzz.tmp
	cat $dir/fuzz.tmp | jq '[.results[]|{url: .url, status: .status, length: .length}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' > $dir/fuzz.txt;
	done;

	# extract js files
	echoTask "Extracting Js Files"
	cat $dir/urls.txt | grep -P "\w+\.js(\?|$)" > $dir/js.txt

	# run secretfinder against js files
	echoTask "Running Secretfinder Against Js Files"
	i=0
	c=`cat $dir/js.txt | wc -l`
	for file in $(cat $dir/js.txt);do
		secretFinder.py -i $file -o cli >> $dir/secrets.txt
		let "i+=1"
		echo -ne "${green}________${i} / ${c} Js files checked ________${reset}\\r" 
	done;

	# look for potentials bugs via gf
	echoTask "Checking Urls Against GF-Patterns"
    doGF $dir/urls.txt	

else 
	domains=~/recon/$1/httpxdomains.txt

	# format domains
	echo "https://$1" > $dir/domains.txt
	cat $domains | grep -E "200|301|302|403" | cut -d [ -f "1" >> $dir/domains.txt

	# # get all urls
	echoTask "Getting All Urls"
	cat $dir/domains.txt  | gau -o $dir/tmp.txt;
	# cat $dir/domains.txt | waybackurls >> $dir/tmp.txt;
	cat $dir/tmp.txt | sort -u > $dir/urls.txt;rm $dir/tmp.txt;
	
	# fuzz/ directory search
	echoTask "Fuzzing For Juicy Files And Directories"
	
	for domain in $(cat $dir/domains.txt);do
	ffuf -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "https://$1/FUZZ" -w ~/wordlists/directory.txt -s -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -o $dir/fuzz.tmp
	cat $dir/fuzz.tmp | jq '[.results[]|{url: .url, status: .status, length: .length}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' > $dir/fuzz.txt;
	done;

	# extract js files
	echoTask "Extracting Js Files"
	cat $dir/urls.txt | grep -P "\w+\.js(\?|$)" | tee -a $dir/js.txt
    
    # run secretfinder against js files
	echoTask "Running Secretfinder Against Js Files"
	i=0
	c=`cat $dir/js.txt | wc -l`
	for file in $(cat $dir/js.txt);do
		secretFinder.py -i $file -o cli >> $dir/secrets.txt
		let "i+=1"
		echo -ne "${green}________${i} / ${c} Js files checked ________${reset}\\r" 
	done;

	# look for potentials bugs via gf
	echoTask "Checking Urls Against GF-Patterns"
    doGF $dir/urls.txt	

fi
