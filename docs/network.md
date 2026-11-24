# Network layout

```mermaid
flowchart TB
    subgraph H["Host-only lab segment"]
      W["Windows VM\nElastic Agent + Sysmon"]
      S["Linux VM\nElastic Agent + Suricata"]
      F["Elastic VM\nFleet Server · TCP 8220"]
      E["Elastic VM\nElasticsearch · TCP 9200"]
      K["Elastic VM\nKibana · loopback TCP 5601"]
      W -->|Policy / TLS| F
      S -->|Policy / TLS| F
      W -->|Events / TLS| E
      S -->|Events / TLS| E
      F -->|Fleet state / TLS| E
      K -->|Query / TLS| E
      W -->|Benign DNS / HTTP markers| S
    end
```

Bind Elasticsearch to the Elastic VM's host-only address for endpoint ingestion. Resolve the hostname used by Elasticsearch and Fleet Server on every agent VM. On a virtual switch without port mirroring, the Linux VM sees traffic to and from itself. Place the marker services on that VM or attach the sensor to the lab mirror.
