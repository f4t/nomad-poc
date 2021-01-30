# Increase log verbosity
log_level = "INFO"
disable_update_check = true

# Setup data dir
data_dir = "/home/vagrant/nomad_clientdata"
bind_addr = "127.0.0.1"

datacenter = "HKD"

# Enable the client
client {
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

consul { address = "127.0.0.1:8500" }
