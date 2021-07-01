#!/bin/bash
# install apache2, ngrok
mkdir ~/recon;
mkdir ~/wordlist;
dir=/usr/local/bin;

# install all dependencies
# wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz;
# tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz;
# echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc;
# source ~/.bashrc;
sudo apt-get install ruby;
sudo apt-get install screen;
sudo apt-get install git;
sudo apt-get install jq;
pip3 install requests;

# install go dependencies
go get -u github.com/tomnomnom/assetfinder;
go get github.com/tomnomnom/hacks/waybackurls;
go get github.com/Ice3man543/SubOver;
go get github.com/haccer/subjack;
go get github.com/ffuf/ffuf;
go get -u github.com/tomnomnom/gf;
GO111MODULE=on go get -u -v github.com/lc/gau;
GO111MODULE=on go get -u -v github.com/projectdiscovery/httpx/cmd/httpx;

# install dependencies via git
git clone https://github.com/maurosoria/dirsearch.git $dir/dirsearch;
git clone https://github.com/projectdiscovery/nuclei.git $dir/nuclei; cd $dir/nuclei/cmd/nuclei/; go build;mv nuclei $dir; cd -;
git clone https://github.com/projectdiscovery/nuclei-templates $dir/nuclei-templates;
git clone https://github.com/defparam/smuggler $dir/smuggler;
git clone https://github.com/1ndianl33t/Gf-Patterns;
git clone https://github.com/aboul3la/Sublist3r.git $dir/sublist3r;
pip3 install -r $dir/sublist3r/requirements.txt
git clone https://github.com/m4ll0k/SecretFinder $dir/secretFinder;
pip3 install -r $dir/secretFinder/requirements.txt


# organize, clean up, download wordlists and misc
mkdir ~/.gf;
wget https://raw.githubusercontent.com/Mad-robot/recon-tools/master/dicc.txt -o ~/wordlist/directory.txt;
wget https://raw.githubusercontent.com/devanshbatham/ParamSpider/master/gf_profiles/potential.json -o ~/.gf/potential.json;
mv $dir/sublist3r/Sublist3r.py $dir/sublist3r/sublist3r.py;
mv $dir/secretFinder/SecretFinder.py $dir/secretFinder/secretFinder.py;
# mv ~/home/go/bin/SubOver ~/home/go/bin/subOver;
mv Gf-Patterns/*.json ~/.gf;
rm -rf Gf-Patterns;
echo 'source $HOME/go/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc;
cp -r $HOME/go/src/github.com/tomnomnom/gf/examples ~/.gf;

echo "
export GOPATH=$HOME/go
export TOOLS=$PATH/usr/local/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$TOOLS/sublist3r
export PATH=$PATH:$TOOLS/dirsearch
export PATH=$PATH:$TOOLS/secretFinder
alias bee="~/bee/src/bee.sh"
" >> ~/.bashrc;source ~/.bashrc;

