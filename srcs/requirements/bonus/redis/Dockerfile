# Base model
FROM debian:11-slim

# Install packages
RUN apt-get update && apt-get install -y \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# Launch redis-server
### --protected-mode no: Disable protected mode
## Cache configuration
### --maxmemory 2mb: Set the maximum memory to 2mb
### --maxmemory-policy allkeys-lru: Set the policy to remove the least recently used keys
CMD ["redis-server", \
    "--protected-mode", "no", \
    "--maxmemory", "2mb", \
    "--maxmemory-policy", "allkeys-lru"]