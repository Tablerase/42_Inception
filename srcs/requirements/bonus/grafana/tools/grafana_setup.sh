#! /bin/bash

# Configure Grafana
## Activate the configuration storage path to allow volume mounting to work
sed -i 's/;data =/data =/' /etc/grafana/grafana.ini
sed -i 's/;logs =/logs =/' /etc/grafana/grafana.ini
sed -i 's/;plugins =/plugins =/' /etc/grafana/grafana.ini
sed -i 's/;provisioning =/provisioning =/' /etc/grafana/grafana.ini

# Launch Grafana Server
grafana-server --homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini