cd /home/vagrant
sudo apt-get update
sudo apt-get install openjdk-7-jre-headless -y

wget https://github.com/elasticsearch/elasticsearch/archive/v0.20.1.tar.gz -O elasticsearch.tar.gz
tar -xf elasticsearch.tar.gz
rm elasticsearch.tar.gz
sudo mv elasticsearch-* elasticsearch
sudo mv elasticsearch /usr/local/share

curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz
sudo mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/
rm -Rf *servicewrapper*
sudo /usr/local/share/elasticsearch/bin/service/elasticsearch install
sudo ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch

sudo service elasticsearch start

#curl http://localhost:9200