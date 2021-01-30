# Increase log verbosity
log_level = "INFO"
disable_update_check = true

# Setup data dir
data_dir = "/tmp/nomad_client"
bind_addr = "0.0.0.0"

datacenter = "HKD"

# Enable the client
client {
  enabled = true
  servers = [
      "10.0.50.101:4647",
      "10.0.50.102:4647",
      "10.0.50.103:4647"
    ]
  template {
      disable_file_sandbox = true
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

// consul { address = "10.0.50.101:8500" }
