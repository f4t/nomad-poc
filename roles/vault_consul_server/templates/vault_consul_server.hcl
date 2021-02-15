bootstrap_expect = 3
#client_addr = "{{ '{{' }} GetInterfaceIP \"eth1\" {{ '}}' }}"
client_addr = "127.0.0.1"
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
encrypt = "5eqeBvL3Ej4jLR8unhcbXUqF5abLAgW2TRU2dm4PEE0="
leave_on_terminate = true
log_level = "INFO"
rejoin_after_leave = true
server = true
retry_join = [
  "10.0.50.41",
  "10.0.50.42",
  "10.0.50.43"
]

ports {
    http = 18500
    dns = 18600
    server = 18300
    grpc = 18502
    serf_lan = 18301
    serf_wan = 18302
}

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
