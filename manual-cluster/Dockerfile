FROM rabbitmq:3.8-management

# ARG for hostname
ARG rabbit_hostname
ENV RABBITMQ_NODENAME=rabbit@${rabbit_hostname}

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Ensure the script has execute permissions
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the script as the container's entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
