[[- $Values := (fileContents "template.json" | parseJSON ) -]]
job "gateways-[[ env "JOB_GATEWAY_HOST" ]]" {
  datacenters = ["HKD"]
  type = "service"

  constraint {
      attribute = "${attr.unique.hostname}"
      value     = "[[ env "JOB_GATEWAY_HOST" ]]"
  }

[[ range $gateway_server, $gateways := $Values.gateways ]]
  [[if eq $gateway_server (env "JOB_GATEWAY_HOST")]]
    [[ range $gateway:= $gateways]]
  group "[[$gateway.name]]" {
    count = 1
    network {
      port "gateway_port" {
        static = [[$gateway.port]]
      }
    }
    task "gateway" {
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
echo "Gateway name: [[$gateway.name]] <br/>" >> index.html
echo "Gateway port: [[$gateway.port]] <br/>" >> index.html
echo "Server name: [[$gateway_server]] <br/>" >> index.html
echo "Licd host: [[ $Values.global.licd.port ]] <br/>" >> index.html
echo "Licd port: [[ $Values.global.licd.host ]] <br/>" >> index.html
cat index.html
python -m SimpleHTTPServer ${NOMAD_PORT_gateway_port}
EOH
      }

      service {
        tags = ["gateway", "[[$gateway.name]]"]
        port = "gateway_port"
      }

      resources {
        cpu = 10
        memory = 10
      }
    }
  }
[[ end ]][[end]][[end]]
}
