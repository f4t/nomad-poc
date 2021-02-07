# Increase log verbosity
log_level = "DEBUG"
disable_update_check = true

# Setup data dir
data_dir = "/home/vagrant/nomad_client/data"
bind_addr = "{{ansible_eth1.ipv4.address}}"

datacenter = "HKD"

# Enable the client
client {
  network_interface = "eth1"
  enabled = true
  template {
      disable_file_sandbox = true
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

tls {
  http = true
  rpc  = true

  ca_file   = "nomad-ca.pem"
  cert_file = "nomad-client.pem"
  key_file  = "nomad-client-key.pem"

  verify_server_hostname = true
  # TODO: should be true in PROD with actual CA certs
  verify_https_client    = false
}

consul { address = "127.0.0.1:8500" }
