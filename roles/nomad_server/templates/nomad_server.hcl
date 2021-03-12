# Increase log verbosity
log_level = "INFO"
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

tls {
  http = true
  rpc  = true

  ca_file   = "nomad-ca.pem"
  cert_file = "nomad-server.pem"
  key_file  = "nomad-server-key.pem"

  verify_server_hostname = true
  # TODO: should be true in PROD with actual CA certs
  verify_https_client    = false
}

#acl {
#  enabled = true
#}

consul { address = "127.0.0.1:8500" }
