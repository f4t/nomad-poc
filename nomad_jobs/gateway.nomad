job "gateway" {
  datacenters = ["HKD"]
  type = "service"

  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "nomad-client-1"
  }

  group "gateway" {
    count = 1
    network {
        port "gateway" {
        static = 7039
        }
    }

    task "gateway" {
      driver = "raw_exec"

      template {
        destination = "local/runner.bash"
        data = <<EOH
#!/bin/bash
echo "Preparing gateway ${NOMAD_META_gateway_name} on $(hostname)"
cd local/
ln -sfv ~/gateway_config/gateways/$(hostname)/${NOMAD_META_gateway_name} gateway
cd gateway/
mkdir -p resources/
ln -sfv ~/packages/gateway/resources/xslt ./resources/xslt
echo "Running gateway ${NOMAD_META_gateway_name} on $(hostname)"
~/bin/gateway -licd-host 10.0.50.32 -licd-port 7041
echo "Gateway ${NOMAD_META_gateway_name} on $(hostname) terminated."
EOH
      }

      config {
        command = "/bin/bash"
        args    = ["local/runner.bash"]
      }

      meta {
        gateway_name = "HK_INNOVATION_PROD"
      }

      service {
        meta {
          gateway_name = "${NOMAD_META_gateway_name}"
        }
        // tags = ["itrs", "http", "urlprefix-/licd"]
        // tags = ["urlprefix-:${NOMAD_PORT_gateway} proto=tcp"]
        tags = ["itrs", "gateway"]
        port = "gateway"
        check {
          type     = "tcp"
          port     = "gateway"
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
