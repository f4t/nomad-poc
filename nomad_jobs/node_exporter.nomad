job "nomad-system" {
  datacenters = ["HKD"]
  type = "system"

  group "agents" {

    network {
      port "node_exporter" {
          static = 9100
      }
    }

    task "nodeexporter" {

      driver = "raw_exec"

      config {
        command = "/bin/bash"
        args    = ["local/runner.bash"]
      }

      template {
        destination = "local/runner.bash"
        data = <<EOH
#!/bin/bash
/home/vagrant/bin/node_exporter
EOH
      }

      service {
        tags = ["node_exporter"]

        port = "node_exporter"

        check {
          type     = "tcp"
          port     = "node_exporter"
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
}

