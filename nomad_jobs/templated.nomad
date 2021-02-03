[[- /* Template defaults as json */ -]]
[[- $Values := (fileContents "template.json" | parseJSON ) -]]
job "templated" {
  datacenters = ["HKD"]
  type = "service"

  constraint {
      attribute = "${attr.unique.hostname}"
      value     = "nomad-client-2"
  }

  group "templated" {
    count = 1

    network {
      port "myport" {}
    }

    task "templated" {
      driver = "raw_exec"
      config {
        command = "/bin/bash"
        args = ["local/runner.bash"]
      }

      template {
        destination = "local/runner.bash"
        data = <<EOH
#!/bin/bash
cd local
echo "Gateway name: _____ <br/>" >> index.html
echo "Gateway port: _____ <br/>" >> index.html
echo "Server name: _____ <br/>" >> index.html
echo "Licd host: [[ $Values.global.licd.port ]] <br/>" >> index.html
echo "Licd port: [[ $Values.global.licd.host ]] <br/>" >> index.html
cat index.html
python -m SimpleHTTPServer ${NOMAD_PORT_myport}
EOH
      }

      service {
        tags = ["http", "urlprefix-/index.html"]
        port = "myport"
      }

      resources {
        cpu = 10
        memory = 10
      }
    }
  }
}