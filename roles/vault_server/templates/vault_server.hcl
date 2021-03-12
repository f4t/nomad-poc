disable_mlock = true

ui = true

listener "tcp" {
  address = "0.0.0.0:8200"
  # tls_disable = true
  tls_cert_file = "/home/vagrant/vault_server/vault-server.pem"
  tls_key_file  = "/home/vagrant/vault_server/vault-server-key.pem"
}

storage "consul" {
  address = "127.0.0.1:8500"
  path = "vault/"
  # token = "<TOKEN from Step 4 - #10>"
}