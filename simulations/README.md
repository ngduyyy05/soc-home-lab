# Isolated validation controls

Run these controls after the endpoint data streams appear in Discover. Record UTC times and source event IDs before checking alerts.

| Technique | Atomic Red Team reference | Lab control | Expected alert |
| --- | --- | --- | --- |
| T1059.001 | `a538de64-1c74-46ed-aa60-b995ed302598`, PowerShell Command Execution | Print the lab marker with the harmless payload below | SOC Lab PowerShell marker |
| T1110.001 | `09480053-2f98-4854-be6e-71ae5f672224`, password guessing technique reference | One manual mistyped password for a disposable account over lab RDP | Failed Remote Interactive Logon when Windows records LogonType 10 |
| Lab control | Local DNS and HTTP markers | Resolve the test name and request the HTTP marker | SOC Lab Suricata marker |

## PowerShell marker

With Invoke-AtomicRedTeam installed locally, use the explicit payload that prints one line. Verify the UUID and `obfuscated_code` parameter in the upstream definition before use. As a separate direct control, run only the final command in plain PowerShell.

```powershell
$marker = "Write-Output 'SOC-LAB-MARKER'"
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($marker))
Invoke-AtomicTest T1059.001 -TestGuids 'a538de64-1c74-46ed-aa60-b995ed302598' -InputArgs @{obfuscated_code = $encoded}
Write-Output 'SOC-LAB-MARKER'
```

[Atomic Red Team T1059.001 reference](https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1059.001/T1059.001.yaml).

## Authentication control

From an isolated Windows VM, connect to the disposable VM using Remote Desktop and make one manual wrong-password attempt for the test account. Network Level Authentication and Windows policy can affect the LogonType. Report an unmatched control if event 4625 type 10 is absent.

## Network controls

Run a local HTTP server on the sensor VM bound to its lab interface. Direct DNS to a lab resolver visible on the monitored segment. Substitute lab addresses in the commands. A DNS negative response or HTTP 404 can still produce the expected signature.

```powershell
Resolve-DnsName -Name marker.lab.test -Type A -DnsOnly -Server <lab-resolver-address>
curl.exe http://<lab-sensor-address>:8000/soc-lab-marker
```

Inspect EVE signature IDs `1000001` and `1000002` and compare them with the Elastic rule alerts. Record the observed results in [the worksheet](../results/coverage.md).
