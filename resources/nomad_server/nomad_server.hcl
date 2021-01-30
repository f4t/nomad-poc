# Increase log verbosity
log_level = "INFO"
disable_update_check = true

# Setup data dir
data_dir = "/home/vagrant/nomad_server/data"
bind_addr = "127.0.0.1"

datacenter = "HKD"

# Enable the server
server {
    enabled = true
    bootstrap_expect = 3
}

consul { address = "127.0.0.1:8500" }
