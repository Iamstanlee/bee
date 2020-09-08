
```
	______   _______  _______  
	(  ___ \ (  ____ \(  ____ \       
	| (   ) )| (    \/| (    \/
	| (__/ / | (__    | (__    
	|  __ (  |  __)   |  __)   
	| (  \ \ | (      | (         
	| )___) )| (____/\| (____/\ 
	|/ \___/ (_______/(_______/ 
```

Bee is a c-tier recon framework, inspired by Harsh-Bothra's [Bheem](https://github.com/harsh-bothra/Bheem)

### Installation
  * clone this repo _```git clone https://github.com/Iamstanlee/bee.git```_
  * ```cd bee;chmod +x install.sh```
  * then run ```./install.sh```


### Usage
  - I've categorized the recon into two
  	* small scope recon eg recon on _example.com_
  	* medium scope recon eg _*.example.com_
  - Either (not both) of the recon category can be run at a time
  - Edit the *new_targets.txt* to contain either small and medium scope targets
  - Save and run _```bee```_
  - For small scope, pass an 's' flag to tell bee it's small scope ie _```bee -s```_

### Tools Used
  * gf
  * nuclei
  * subfinder
  * assetfinder
  * sublist3r
  * httpx
  * gau
  * waybackurls


