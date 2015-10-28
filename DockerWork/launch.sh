#SETUP DIRECTORY

mkdir -p /space/data/db1/db
mkdir -p /space/data/db2/db
mkdir -p /space/data/db3/db
mkdir -p /space/data/db4/db

docker run -p 37017:27017 -v /space/data/db1:/data mongodb &
echo $?
docker run -p 37018:27017 -v /space/data/db2:/data mongodb &
echo $?
docker run -p 37019:27017 -v /space/data/db3:/data mongodb &
echo $?
docker run -p 37020:27017 -v /space/data/db4:/data mongodb &
echo $?

