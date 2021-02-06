job "fabio" {
  datacenters = ["HKD"]
  type = "service"

  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "nomad-client-2"
  }

  group "fabio" {
    count = 1
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