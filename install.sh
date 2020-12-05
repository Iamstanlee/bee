#!/bin/sh
# sudo su
# install all dependencies
sudo apt-get install golang;
sudo apt-get install python3;
sudo apt-get install python3-pip;
sudo apt-get install ruby;
sudo apt-get install screen;
sudo apt-get install git;
wget https://golang.org/dl/go1.15.1.linux-amd64.tar.gz; 
tar -C /usr/local -xzf go1.15.1.linux-amd64.tar.gz;
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc;source ~/.bashrc;

pip install requests;
mkdir ~/recon;
mkdir ~/wordlist;
dir=/usr/local/bin;

# install go dependencies
go get -u github.com/tomnomnom/assetfinder;
go get github.com/tomnomnom/hacks/waybackurls;
go get github.com/Ice3man543/SubOver;
go get github.com/haccer/subjack;
go get github.com/ffuf/ffuf;
go get -u github.com/tomnomnom/gf;
GO111MODULE=on go get -u -v github.com/lc/gau;
GO111MODULE=on go get -u -v github.com/projectdiscovery/httpx/cmd/httpx;
# GO111MODULE=on go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei;

# install dependencies via git

git clone https://github.com/maurosoria/dirsearch.git $dir/dirsearch;
git clone https://github.com/projectdiscovery/nuclei.git $dir/nuclei; cd $dir/nuclei/cmd/nuclei/; go build;mv nuclei $dir; cd;
git clone https://github.com/projectdiscovery/nuclei-templates $dir/nuclei-templates;
git clone https://github.com/defparam/smuggler $dir/smuggler;
# git clone https://github.com/FortyNorthSecurity/EyeWitness.git $dir/eyeWitness
# chmod +x $dir/eyeWitness/Python/setup/setup.sh
# bash $dir/eyeWitness/Python/setup/setup.sh

git clone https://github.com/1ndianl33t/Gf-Patterns;


# git clone https://github.com/devanshbatham/FavFreak $dir/favFreak;
# pip install -r $dir/favFreak/requirements.txt

git clone https://github.com/aboul3la/Sublist3r.git $dir/sublist3r;
pip install -r $dir/sublist3r/requirements.txt

git clone https://github.com/m4ll0k/SecretFinder $dir/secretFinder;
pip install -r $dir/secretFinder/requirements.txt


# organize, clean up, download wordlists and misc
mkdir ~/.gf;
wget https://raw.githubusercontent.com/Mad-robot/recon-tools/master/dicc.txt -o ~/wordlist/directory.txt;
wget https://raw.githubusercontent.com/devanshbatham/ParamSpider/master/gf_profiles/potential.json -o ~/.gf/potential.json;
mv $dir/sublist3r/Sublist3r.py $dir/sublist3r/sublist3r.py;
mv $dir/secretFinder/SecretFinder.py $dir/secretFinder/secretFinder.py;
mv ~/home/go/bin/SubOver ~/home/go/bin/subOver;
mv Gf-Patterns/*.json ~/.gf;
rm -rf Gf-Patterns;
echo 'source $HOME/go/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc;
cp -r $HOME/go/src/github.com/tomnomnom/gf/examples ~/.gf;

echo "
export GOPATH=$HOME/go
export TOOLS=$PATH:/usr/local/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$TOOLS/sublist3r
export PATH=$PATH:$TOOLS/dirsearch
export PATH=$PATH:$TOOLS/arjun
export PATH=$PATH:$TOOLS/linkFinder
export PATH:$PATH:$TOOLS/eyeWitness/Python
export PATH=$PATH:$TOOLS/secretFinder
alias bee="~/bee/src/bee.sh"
" >> ~/.bashrc;source ~/.bashrc;

