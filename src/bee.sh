#!/bin/bash
echo '
 ______   _______  _______  
(  ___ \ (  ____ \(  ____ \       
| (   ) )| (    \/| (    \/
| (__/ / | (__    | (__    
|  __ (  |  __)   |  __)   
| (  \ \ | (      | (         
| )___) )| (____/\| (____/\ 
|/ \___/ (_______/(_______/ with <3 by stanlee

'
dir=~/bee/src
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# -s for small scope recon eg "hackerone.com"
# -m/none for medium scope recon eg "*.hackerone.com"
function doRecon {
        if [ "$2" = "-s" ]; then
                for url in $(cat $1); do
                        echo '_____________________________________________'
                        echo  "${red} Testing : ${green} ${url} ${reset}"
                        echo '_____________________________________________'
                        echo  "${red} Performing : ${green} URL Extraction For Potential Vulnerabilities ${reset}"
                        echo '----------------------------------------------------------------------'           
                        $dir/discovery.sh $url $2 $3;
                        echo '______________________________________________________________________'
                        echo  "${red} Performing : ${green} Nuclei Scan ${reset}"
                        echo '----------------------------------------------------------------------'         
                        $dir/nuclear.sh $url;
                        echo '_____________________________________________'
                        echo  "${red} Finished Testing : ${green} ${url} ${reset}"
                        echo '---------------------------------------------'
                done
        else 
                for url in $(cat $1); do
                        echo '_____________________________________________'
                        echo  "${red} Testing : ${green} ${url} ${reset}"
                        echo '---------------------------------------------'
                        echo '_________________________________________________________'
                        echo  "${red} Performing : ${green} Subdomain Scanning & Resolving ${reset}"
                        echo '---------------------------------------------------------'
                        $dir/resolver.sh $url $2;
                        echo '______________________________________________________________________'
                        echo  "${red} Performing : ${green} URL Extraction for Potential Vulnerabilities ${reset}"
                        echo '----------------------------------------------------------------------'           
                        $dir/discovery.sh $url $2;
                        echo '______________________________________________________________________'
                        echo  "${red} Performing : ${green} Nuclei Scan ${reset}"
                        echo '----------------------------------------------------------------------'         
                        $dir/nuclear.sh $url;
                        echo '_____________________________________________'
                        echo  "${red} Finished Testing : ${green} ${url} ${reset}"
                        echo '---------------------------------------------'
                done
        fi
}

doRecon ~/bee/newtargets.txt $1
