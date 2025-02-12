#!/bin/bash
set -e  # Exit on error

echo "Starting RabbitMQ setup..."

# Start RabbitMQ in detached mode
rabbitmq-server -detached

# Wait for RabbitMQ to be ready
sleep 5

echo "Stopping RabbitMQ to configure clustering..."
rabbitmqctl stop_app
rabbitmqctl reset

# Join cluster if this is not the first node
if [ "$RABBITMQ_NODENAME" != "rabbit@rabbit-1" ]; then
  echo "Joining cluster with rabbit@rabbit-1..."
  rabbitmqctl join_cluster rabbit@rabbit-1
fi

echo "Starting RabbitMQ..."
rabbitmqctl start_app

# Keep container running
tail -f /dev/null