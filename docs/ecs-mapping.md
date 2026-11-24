# ECS field mapping

The Fleet integrations supply Elastic ingest pipelines. Check installed integration versions in Fleet and confirm normalization against incoming documents in Discover.

| Input field or record component | ECS field | Integration-native pivot |
| --- | --- | --- |
| Windows system EventID | `event.code` | `winlog.event_id`, `winlog.channel` |
| Sysmon process Image / CommandLine | `process.executable`, `process.command_line` | `winlog.event_data.Image`, `winlog.event_data.CommandLine` where retained |
| Windows Security target account / network address | `user.name`, `source.ip` when available | `winlog.event_data.TargetUserName`, `winlog.event_data.IpAddress`, `winlog.event_data.LogonType` |
| PowerShell script block | `event.code`, `host.name` for pivots | `powershell.file.script_block_text` or retained `winlog.event_data.ScriptBlockText` |
| Linux auth syslog time / program / SSH peer | `@timestamp`, `process.name`, `source.ip` when parsed | `event.dataset: system.auth` |
| Suricata EVE src_ip / dest_ip / flow metadata | `source.ip`, `destination.ip`, `network.community_id` | `suricata.eve.alert.signature_id` |

Check `data_stream.namespace: lab` and use `event.dataset` to distinguish the sources. Validate types in the Discover field list before adjusting a rule. A missing field can mean that the original event did not carry the corresponding value.
