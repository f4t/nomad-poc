bind_addr = "{{ '{{' }} GetInterfaceIP \"eth1\" {{ '}}' }}"
client_addr = "127.0.0.1"
datacenter = "HKD"
data_dir = "./data"
domain = "consul"
# TODO: Gossip encryption key should come from Vault
encrypt = "FxHaxL10ceWXGc8/E8YADZS1bJN01juaX9hNi4rgYOI="
log_level = "INFO"
enable_syslog = true
enable_debug = true
server = false
rejoin_after_leave = true
retry_join = [
  "10.0.50.11",
  "10.0.50.12",
  "10.0.50.13"
]

disable_update_check = true

verify_incoming = false
verify_outgoing = true
verify_server_hostname = true
ca_file = "consul-agent-ca.pem"
auto_encrypt = {
  tls = true
}
