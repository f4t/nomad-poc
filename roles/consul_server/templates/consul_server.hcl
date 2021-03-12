bootstrap_expect = 3
client_addr = "0.0.0.0"
bind_addr = "{{ '{{' }} GetInterfaceIP \"eth1\" {{ '}}' }}"
datacenter = "HKD"
data_dir = "./data"
domain = "consul"
enable_script_checks = true
dns_config {
  enable_truncate = true
  only_passing = true
}
enable_syslog = true
# TODO: Gossip encryption key should come from Vault
encrypt = "FxHaxL10ceWXGc8/E8YADZS1bJN01juaX9hNi4rgYOI="
leave_on_terminate = true
log_level = "INFO"
rejoin_after_leave = true
server = true
retry_join = [
  "10.0.50.11",
  "10.0.50.12",
  "10.0.50.13"
]

# ports {
#  http = -1
#  https = 8501
#}

ui_config {
  enabled = true
}

disable_update_check = true

verify_incoming = true
verify_outgoing = true
verify_server_hostname = true
ca_file = "consul-agent-ca.pem"
cert_file = "HKD-server-consul-0.pem"
key_file = "HKD-server-consul-0-key.pem"
auto_encrypt {
  allow_tls = true
}
