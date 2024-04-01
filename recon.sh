#!/bin/bash

domain=$1 		# ussage ./recon.sh <tcm-sec.com> this will set the site to our variable
RED="\033[1;31m"  	# making pretty colors in a bash scripts
RESET="\033[0m" 	#resets the color

info_path=$domain/info 			#making directory for info
sub_domain=$domain/subdomains 		#making directory for subdomains	
screenshot_path=$domain/screenshots 	#making directory for screenshots

if [ ! -d "$domain" ];then 	#making a directory for our variable if it doesn't exist
	mkdir $domain
fi

if [ ! -d "$info_path" ];then 	#making a directory for our variable if it doesn't exist
	mkdir $info_path
fi

if [ ! -d "$sub_domain" ];then 	#making a directory for our variable if it doesn't exist
	mkdir $sub_domain
fi

if [ ! -d "$screenshot_path" ];then 	#making a directory for our variable if it doesn't exist
	mkdir $screenshot_path
fi

echo -e "${RED} [+] Checkin' who it is . . . ${RESET}"
whois $1 > $info_path/whois.txt

echo -e "${RED} [+] Launching subfinder . . . ${RESET}"
subfinder -d $domain > $subdomain_path/found.txt

echo -e "${RED} [+] Running assetfinder . . . ${RESET}"
assetfinder $domain | grep $domain >> $subdomain_path/found.txt

#echo -e "${RED} [+] Running Amass.  This could take a while . . . ${RESET}"
#amass enum -e $domain >> $subdomain_path/found.txt

echo -e "${RED} [+] Checkin' what's alive . . . ${RESET}"
cat $subdomain_path/found.txt | grep $domain | sort -u | httprobe -prefer-https | grep https | sed 's/https\?:\/\///' | tee -a $subdomain_path/alive.txt
#takes the found subdomains and sorts them and stripps out the https stuff and 443 at the end, then writes to a file and print out to the screen

echo -e "${RED} [+] Taken dem screenshotz . . . ${RESET}"
gowitness file -f $subdomain/alive.txt -P $screenshot_path/ --no-http






