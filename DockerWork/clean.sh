docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
sudo docker build -f mongodb.docker -t mongodb .
#sudo docker run -t mongodb
