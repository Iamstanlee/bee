#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


function echoTask {
	echo "${green}_________$1_________${reset}"
}

"$@"