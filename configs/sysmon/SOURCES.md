# Sysmon baseline

This lab configuration follows the event families and image suffix filters used in SwiftOnSecurity's Sysmon baseline. The XML uses a narrower lab policy with full process creation and DNS telemetry, scoped PowerShell network events and a file filter for the lab marker. Full process and DNS telemetry can be noisy.

- [SwiftOnSecurity Sysmon configuration](https://github.com/SwiftOnSecurity/sysmon-config)
- [Microsoft Sysinternals Sysmon documentation](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
