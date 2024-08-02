# Base Model
FROM debian:11-slim

# Install packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    software-properties-common \
    wget \
    gpg
## Add Grafana repository key
RUN mkdir -p /etc/apt/keyrings/
RUN wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
## Add Grafana repository
RUN echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

# Install Grafana
RUN apt-get update && apt-get install -y grafana

## Configure Grafana
COPY tools/grafana_setup.sh /tmp/grafana_setup.sh
RUN chmod +x /tmp/grafana_setup.sh

# Launch Grafana Server
ENTRYPOINT [ "/tmp/grafana_setup.sh" ]