# Increase log verbosity
log_level = "DEBUG"
disable_update_check = true

# Setup data dir
data_dir = "/home/vagrant/nomad_server/data"
bind_addr = "{{ansible_eth1.ipv4.address}}"

datacenter = "HKD"

# Enable the server
server {
  enabled = true
  bootstrap_expect = 3
  # Gossip traffic encryption:
  # TODO: this should come from Vault
  encrypt = "WSEw4cBdgGYTkDUAyHFKal1DtysVOzNhhzdeEgpGHys="
}

consul { address = "127.0.0.1:8500" }
