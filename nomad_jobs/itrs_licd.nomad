job "itrs" {
  datacenters = ["HKD"]
  type = "service"

  // constraint {
  //   attribute = "${node.unique.hostname}"
  //   value     = "nomad-client-2"
  // }

  group "geneos" {
    count = 1

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
        tags = ["pioupiou", "http", "urlprefix-:1234 proto=tcp"]
        port = "licd"
        check {
          type     = "tcp"
          port     = "licd"
          interval = "300s"
          timeout  = "30s"
        }
      }

      resources {
        cpu = 10
        memory = 10
      }
    }
  }
}
