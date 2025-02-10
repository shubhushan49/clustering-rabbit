#!/bin/bash
docker network create rabbits

docker run -d --net rabbits \
    --hostname rabbit-1 \
    -p 8081:15672 \
    --name rabbit-1 \
    -v $(pwd)/erlang.cookie:/var/lib/rabbitmq/.erlang.cookie \
    -v $(pwd)/config/rabbit-1:/etc/rabbitmq/ \
    rabbitmq:3.8-management

docker run -d --net rabbits \
    --hostname rabbit-2 \
    -p 8082:15672 \
    --name rabbit-2 \
    -v $(pwd)/erlang.cookie:/var/lib/rabbitmq/.erlang.cookie \
    -v $(pwd)/config/rabbit-2:/etc/rabbitmq/ \
    rabbitmq:3.8-management

docker run -d --net rabbits \
    --hostname rabbit-3 \
    -p 8083:15672 \
    --name rabbit-3 \
    -v $(pwd)/erlang.cookie:/var/lib/rabbitmq/.erlang.cookie \
    -v $(pwd)/config/rabbit-3:/etc/rabbitmq/ \
    rabbitmq:3.8-management

echo "Waiting for RabbitMQ nodes to initialize"

docker exec -it rabbit-1 rabbitmq-plugins enable rabbitmq_management

sleep 5


# prep rabbit2
docker exec -it rabbit-2 rabbitmqctl stop_app
docker exec -it rabbit-2 rabbitmqctl reset
docker exec -it rabbit-2 rabbitmqctl join_cluster rabbit@rabbit-1
docker exec -it rabbit-2 rabbitmq-plugins enable rabbitmq_management
docker exec -it rabbit-2 rabbitmqctl start_app

# prep rabbit3
docker exec -it rabbit-3 rabbitmqctl stop_app
docker exec -it rabbit-3 rabbitmqctl reset
docker exec -it rabbit-3 rabbitmqctl join_cluster rabbit@rabbit-1
docker exec -it rabbit-3 rabbitmq-plugins enable rabbitmq_management
docker exec -it rabbit-3 rabbitmqctl start_app
