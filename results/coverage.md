# Detection coverage and benign baseline

Record one row per run. Scope detections by rule name, host and UTC time. Document the source event, ingestion delay and evidence. Use Y for a matched alert and N for a missed alert after checking the rule schedule and ingestion.

| Technique | Test | Expected alert | Detected Y/N | False positives | Notes |
| --- | --- | --- | --- | --- | --- |
| T1059.001 | Harmless PowerShell marker | SOC Lab PowerShell marker | TODO(user): fill after running | TODO(user): fill after running | TODO(user): fill after running |
| T1110.001 | One manual lab sign-in failure | Failed Remote Interactive Logon when LogonType is 10 | TODO(user): fill after running | TODO(user): fill after running | TODO(user): fill after running |
| Lab control | DNS marker | SOC Lab Suricata marker | TODO(user): fill after running | TODO(user): fill after running | TODO(user): fill after running |
| Lab control | HTTP marker | SOC Lab Suricata marker | TODO(user): fill after running | TODO(user): fill after running | TODO(user): fill after running |

## Benign baseline

1. Choose a fixed window with the same sensors and rule versions. Record UTC times, policy versions and active data streams.
2. Perform routine successful sign-ins, file reads, normal PowerShell administration and isolated browsing with alternate DNS names and paths. Exclude the marker window from the baseline.
3. Review and label each alert using its underlying telemetry. Count reviewed alerts and confirmed false positives. Compare later revisions over equivalent windows.

Window, data volume, reviewed alerts, false positives and tuning decisions — TODO(user): fill after running.
