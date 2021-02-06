[[- $Values := (fileContents "gateways.json" | parseJSON ) -]]
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
env

echo "Pulling gateway config git repo"
cd ${GATEWAY_REPO_PATH}/
git pull

echo "Preparing gateway ${NOMAD_META_gateway_name} on $(hostname)"
pwd
cd ${NOMAD_TASK_DIR}
pwd
ln -sfnv ${GATEWAY_REPO_PATH}/gateways/$(hostname)/${NOMAD_META_gateway_name} gateway
cd gateway/
mkdir -p resources/
ln -sfnv ~/packages/gateway/resources/xslt ./resources/xslt
ln -sfnv ~/packages/gateway/resources/standardisedformats ./resources/standardisedformats

echo "Running gateway ${NOMAD_META_gateway_name} on $(hostname)"
# https://docs.itrsgroup.com/docs/geneos/5.5.0/Gateway_Reference_Guide/geneos_gateway_core.html#Gateway_Command_Line_options
~/bin/gateway \
  ${NOMAD_META_gateway_name}  `# dummy argument - for process identification`\
  -port [[$gateway.port]] \
  -licd-host [[$Values.global.licd.host]] \
  -licd-port [[$Values.global.licd.port]] \
  -setup-comments required \
  `# -max-severity none ` \
  -hooks-dir ${GATEWAY_REPO_PATH}/scripts/hooks

echo "Gateway ${NOMAD_META_gateway_name} on $(hostname) terminated."EOH
EOH
      }

      meta {
        gateway_name = "[[$gateway.name]]"
      }

      env {
        GATEWAY_REPO_PATH = "[[$Values.global.paths.config_repo]]"
      }

      service {
        meta {
          gateway_name = "${NOMAD_META_gateway_name}"
        }
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
