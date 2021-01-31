job "job" {
  datacenters = ["HKD"]
  type = "service"

  constraint {
    attribute = "${node.unique.hostname}"
    value     = "nomad-client-2"
  }

  group "group" {
    count = 100

    network {
      port "piouhttp" {}
    }

    task "task" {

      driver = "raw_exec"

      config {
        command = "/bin/bash"
        args    = ["local/runner.bash"]
      }

      template {
        destination = "local/runner.bash"
        data = <<EOH
#!/bin/bash
echo "Salut toi bienvenue sur $(hostname)" > local/index.html
cd local/
python -m SimpleHTTPServer ${NOMAD_PORT_piouhttp}
EOH
      }

      service {
        tags = ["pioupiou", "http"]

        port = "piouhttp"

        check {
          type     = "tcp"
          port     = "piouhttp"
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

