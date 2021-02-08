job "licd" {
  datacenters = ["HKD"]
  type = "service"

  group "licd" {
    count = 1
    constraint {
      attribute = "${attr.unique.hostname}"
      value     = "nomad-client-1"
    }

    network {
      port "licd" {}
    }

    task "licd" {

      driver = "raw_exec"

      config {
        command = "/bin/bash"
        args    = ["local/runner.bash"]
      }

      template {
        destination = "local/runner.bash"
        data = <<EOH
#!/bin/bash
cd local/
cp ~/not_so_secrets/geneos.lic . # TODO: this should go to Vault
~/bin/licd -port ${NOMAD_PORT_licd}
EOH
      }

      service {
        // tags = ["itrs", "http", "urlprefix-/licd"]
        tags = ["urlprefix-:7041 proto=tcp"]
        port = "licd"
        check {
          type     = "tcp"
          port     = "licd"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu = 10
        memory = 10
      }
    }
  }

  group "licd-fabio" {
    count = 1
    constraint {
      attribute = "${attr.unique.hostname}"
      value     = "nomad-client-2"
    }
    task "fabio" {
      driver = "raw_exec"
      config {
        command = "/bin/bash"
        args    = ["local/runner.bash"]
      }

      template {
        destination = "local/runner.bash"
        data = <<EOH
#!/bin/bash
export LISTEN_IP=$(/usr/sbin/ifconfig eth1 | grep 'inet ' | awk '{print $2}')

# Regular HTTP proxy:
#~/bin/fabio -ui.addr ${LISTEN_IP}:9998 -proxy.addr ${LISTEN_IP}:9999
# ~/bin/fabio -proxy.strategy=rr

# TCP : https://fabiolb.net/feature/tcp-proxy/
# Single-purpose proxy on 1 specified port only
~/bin/fabio -ui.addr ${LISTEN_IP}:9998 -proxy.addr "${LISTEN_IP}:7041;proto=tcp"

# Dynamic TCP: https://fabiolb.net/feature/tcp-dynamic-proxy/
# Will dynamically open a TCP port based on consul registered tags
#~/bin/fabio -ui.addr ${LISTEN_IP}:9998 -proxy.addr "${LISTEN_IP};proto=tcp-dynamic;refresh=5s"
EOH
      }
    }
  }
}
