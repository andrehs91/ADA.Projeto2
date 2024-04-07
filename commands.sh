# ------------------------------------------------------------------------------

docker build -f ADA.Consumer/Dockerfile -t 91andrehs/ada.consumer .
docker build -f ADA.Producer/Dockerfile -t 91andrehs/ada.producer .

# ------------------------------------------------------------------------------

docker run --name rabbitmq -d --rm -p 5672:5672 -p 15672:15672 rabbitmq:3.13-management
docker run --name redis -d --rm -p 6379:6379 -p 8001:8001 redis/redis-stack:latest
docker run --name minio -d --rm -p 9000:9000 -p 9001:9001 quay.io/minio/minio server /data --console-address ":9001"

# ------------------------------------------------------------------------------

docker run --name consumer -d --rm 91andrehs/ada.consumer
docker run --name producer -d --rm -p 8080:8080 -p 8081:8081 91andrehs/ada.producer

# ------------------------------------------------------------------------------