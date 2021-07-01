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

- requirements

  - [Golang](https://golang.org/doc/install)
  - sudo apt install python3
  - sudo apt install python3-pip

- clone this repo
  ```
  git clone https://github.com/Iamstanlee/bee.git
  cd bee;chmod +x install.sh
  ```
- then run
  ```
  ./install.sh
  ```

### Usage

- I've categorized the recon into two
  - small scope recon eg recon on _example.com_
  - medium scope recon eg _\*.example.com_
- Either (not both) of the recon category can be run at a time
- Create a new file _newtargets.txt_ to contain either small and medium scope targets
- Save and run `bee`
- For small scope, pass an 's' flag to tell bee it's small scope ie `bee -s`

### Tools Used

- gf
- nuclei
- subfinder
- assetfinder
- sublist3r
- httpx
- gau
- waybackurls
