# Setup

## Elasticsearch and Kibana

1. Prepare the VMs as shown in [the network layout](network.md) and follow the Linux host prerequisites in [Elastic's Docker guide](https://www.elastic.co/guide/en/elasticsearch/reference/8.19/docker.html), including `vm.max_map_count`.
2. Copy `.env.example` to `.env`. Generate independent random alphanumeric values for both passwords (at least 20 characters) and the Kibana encrypted saved objects key (at least 32 characters). Set `ES_BIND_HOST` to your Elastic VM's host-only address. Set `ES_LAB_DNS` to a name that resolves to that address from each VM. Choose that name before generating the initial certificate.
3. Start the stack on the Elastic VM and copy its public CA for the Fleet setup.

```sh
docker compose config --quiet
docker compose up -d
docker compose ps
docker compose cp kibana:/usr/share/kibana/config/ca/ca.crt ./elastic-ca.crt
```

4. Sign in at `http://localhost:5601` from the Elastic VM using the built-in Elastic administrator and your local password. Kibana needs package registry access to install the integrations, or an [offline package registry](https://www.elastic.co/docs/reference/fleet/air-gapped).

## Fleet Server and agents

1. Open Fleet settings. Set the default Elasticsearch output to `https://elastic.lab.test:9200`, substituting your configured DNS name. Set the Elasticsearch CA trusted fingerprint from `openssl x509 -fingerprint -sha256 -noout -in elastic-ca.crt` (use the hex value with separators removed).
2. Add a Fleet Server in **Advanced** mode. Issue a certificate and key for the Fleet hostname with a lab CA using [Elastic's TLS guide](https://www.elastic.co/docs/reference/fleet/secure-connections). Set the Fleet URL to the resulting HTTPS hostname on port 8220. On the Elastic VM, install the matching Elastic Agent from the command generated in Kibana. Supply the Elasticsearch CA via `--fleet-server-es-ca` and provide the Fleet certificate, key and CA with the flags shown in the guide. Verify the server appears as Healthy.
3. Create Windows and Linux policies with namespace `lab`. Configure the [integration settings](../configs/elastic/fleet-integrations.md), then enroll the agents with the OS-specific commands in Fleet, adding the Fleet CA through `--certificate-authorities`. Keep the enrollment tokens local.

## Sensors and saved objects

1. In the Windows VM, install Microsoft Sysmon with `Sysmon64.exe -accepteula -i <path-to-sysmon.xml>` from an elevated shell. For an existing installation use `Sysmon64.exe -c <path-to-sysmon.xml>`. Enable **Turn on PowerShell Script Block Logging** in local policy. Ensure **Audit Logon** success and failure is enabled.
2. On the Linux sensor, back up the local Suricata settings, then install [suricata.yaml](../configs/suricata/suricata.yaml) and [lab.rules](../configs/suricata/lab.rules) in `/etc/suricata`. Replace the sample `HOME_NET` with your isolated subnet. Run `sudo suricata -T -c /etc/suricata/suricata.yaml`. Configure the packaged service to capture the lab interface or run the sensor with `sudo suricata -c /etc/suricata/suricata.yaml -i <lab-interface>`. Confirm EVE records arrive at `/var/log/suricata/eve.json`.
3. In Discover verify each stream using [the ECS guide](ecs-mapping.md). Import `detections/dashboard.ndjson` under **Stack Management → Saved Objects**. Import `detections/rules.ndjson` under **Security → Rules → Detection rules** and enable each custom rule. Set a time range covering the controls, then follow [the validation plan](../simulations/README.md).

Use `docker compose down` to stop the lab while keeping its named volumes.
