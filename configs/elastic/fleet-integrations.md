# Elastic Agent integration settings

Use namespace `lab` on each data stream and keep integration-provided ingest pipelines enabled.

| Policy | Integration | Stream selection or path | Expected data stream |
| --- | --- | --- | --- |
| Windows | Windows | Enable Sysmon Operational | `logs-windows.sysmon_operational-lab` |
| Windows | Windows | Enable PowerShell Operational | `logs-windows.powershell_operational-lab` |
| Windows | System | Windows Security channel | `logs-system.security-lab` |
| Linux | System | Authentication logs, path `/var/log/auth.log` on a VM with rsyslog | `logs-system.auth-lab` |
| Linux | Suricata | EVE file, path `/var/log/suricata/eve.json` | `logs-suricata.eve-lab` |

Give each agent read access to its local channels and files. Keep one collection input per channel or log path to avoid duplicate ingestion. Use integration settings to set the Linux time zone if auth.log omits its offset. The Fleet policies operate with the TLS output described in [the setup guide](../../docs/setup.md).

- [Elastic Windows integration](https://www.elastic.co/docs/reference/integrations/windows)
- [Elastic System integration](https://www.elastic.co/docs/reference/integrations/system)
- [Elastic Suricata integration](https://www.elastic.co/docs/reference/integrations/suricata)
