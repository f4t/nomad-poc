job "licd" {
  datacenters = ["HKD"]
  type = "service"

  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "nomad-client-1"
  }

  group "licd" {
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
        // tags = ["urlprefix-:1234 proto=tcp"]
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
}
