job "fabio" {
  datacenters = ["HKD"]
  type = "service"

  // constraint {
  //   attribute = "${node.unique.hostname}"
  //   value     = "nomad-client-1"
  // }

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
# ~/bin/fabio -proxy.strategy=rr
~/bin/fabio -ui.addr ${LISTEN_IP}:9998 -proxy.addr ${LISTEN_IP}:9999
EOH
      }
    }
  }
}