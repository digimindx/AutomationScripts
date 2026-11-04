#requires -Version 5.1
<##
.SYNOPSIS
    Measures network traffic for listening TCP and UDP ports on Windows Server.

.DESCRIPTION
    The script enumerates listening ports and their owning services/processes,
    then uses tshark/Npcap to capture packets for a chosen duration. It reports
    received and transmitted on-wire bytes for each port.

.EXAMPLE
    .\port-traffic-windows.ps1 -ListInterfaces
    .\port-traffic-windows.ps1 -Interface 1 -IntervalSeconds 10
##>

[CmdletBinding()]
param(
    [ValidateRange(1, 3600)]
    [int]$IntervalSeconds = 10,

    [string]$Interface,

    [switch]$ListInterfaces,

    [string]$TsharkPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Find-Tshark {
    param([string]$RequestedPath)

    if ($RequestedPath) {
        if (-not (Test-Path -LiteralPath $RequestedPath)) {
            throw "tshark.exe was not found at: $RequestedPath"
        }
        return (Resolve-Path -LiteralPath $RequestedPath).Path
    }

    $command = Get-Command tshark.exe -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }

    $standardPath = 'C:\Program Files\Wireshark\tshark.exe'
    if (Test-Path -LiteralPath $standardPath) { return $standardPath }

    throw @"
tshark.exe was not found. Install Wireshark with Npcap, then run this script again.
Alternatively, pass its path with -TsharkPath 'C:\Program Files\Wireshark\tshark.exe'.
"@
}

$tshark = Find-Tshark -RequestedPath $TsharkPath

if ($ListInterfaces) {
    & $tshark -D
    exit $LASTEXITCODE
}

if (-not $Interface) {
    throw "Specify -Interface. Run '.\port-traffic-windows.ps1 -ListInterfaces' to view capture interfaces."
}

# Create a PID -> Windows service lookup once, avoiding one CIM query per port.
$serviceByPid = @{}
Get-CimInstance -ClassName Win32_Service | Where-Object { $_.ProcessId -gt 0 } | ForEach-Object {
    if (-not $serviceByPid.ContainsKey([int]$_.ProcessId)) {
        $serviceByPid[[int]$_.ProcessId] = $_.DisplayName
    }
}

function Get-OwnerName {
    param([int]$ProcessId)

    if ($serviceByPid.ContainsKey($ProcessId)) { return $serviceByPid[$ProcessId] }
    try { return (Get-Process -Id $ProcessId -ErrorAction Stop).ProcessName }
    catch { return 'Unknown or protected process' }
}

# Each entry represents a listening TCP port or a locally bound UDP endpoint.
$ports = @{}
Get-NetTCPConnection -State Listen | ForEach-Object {
    $key = "tcp:$($_.LocalPort)"
    if (-not $ports.ContainsKey($key)) {
        $ports[$key] = [pscustomobject]@{
            Protocol = 'TCP'; Port = [int]$_.LocalPort; PID = [int]$_.OwningProcess
            Service = Get-OwnerName -ProcessId ([int]$_.OwningProcess)
            ReceivedBytes = [int64]0; SentBytes = [int64]0; Packets = [int64]0
        }
    }
}

Get-NetUDPEndpoint | ForEach-Object {
    $key = "udp:$($_.LocalPort)"
    if (-not $ports.ContainsKey($key)) {
        $ports[$key] = [pscustomobject]@{
            Protocol = 'UDP'; Port = [int]$_.LocalPort; PID = [int]$_.OwningProcess
            Service = Get-OwnerName -ProcessId ([int]$_.OwningProcess)
            ReceivedBytes = [int64]0; SentBytes = [int64]0; Packets = [int64]0
        }
    }
}

if ($ports.Count -eq 0) {
    Write-Warning 'No listening TCP ports or bound UDP endpoints were found.'
    exit 0
}

# Limit capture to the discovered ports so the trace remains small.
$captureFilter = ($ports.Values | ForEach-Object {
    "$( $_.Protocol.ToLowerInvariant() ) port $( $_.Port )"
} | Sort-Object -Unique) -join ' or '

Write-Host "Capturing traffic for $($ports.Count) local port(s) for $IntervalSeconds second(s)..." -ForegroundColor Cyan

# Fields are pipe-separated. Frame length includes Ethernet/link-layer overhead where present.
$tsharkArguments = @(
    '-l', '-i', $Interface, '-a', "duration:$IntervalSeconds", '-f', $captureFilter,
    '-T', 'fields', '-E', 'separator=|',
    '-e', 'tcp.srcport', '-e', 'tcp.dstport',
    '-e', 'udp.srcport', '-e', 'udp.dstport', '-e', 'frame.len'
)

& $tshark @tsharkArguments | ForEach-Object {
    $fields = $_ -split '\|', 5
    if ($fields.Count -ne 5) { return }

    $tcpSource, $tcpDestination, $udpSource, $udpDestination, $length = $fields
    [int64]$bytes = 0
    if (-not [int64]::TryParse($length, [ref]$bytes)) { return }

    $protocol = $null; $sourcePort = $null; $destinationPort = $null
    if ($tcpSource) {
        $protocol = 'tcp'; $sourcePort = $tcpSource; $destinationPort = $tcpDestination
    } elseif ($udpSource) {
        $protocol = 'udp'; $sourcePort = $udpSource; $destinationPort = $udpDestination
    } else { return }

    # A local source port means outbound data; a local destination port means inbound data.
    $sourceKey = "$protocol`:$sourcePort"
    $destinationKey = "$protocol`:$destinationPort"
    if ($ports.ContainsKey($sourceKey)) {
        $ports[$sourceKey].SentBytes += $bytes
        $ports[$sourceKey].Packets++
    } elseif ($ports.ContainsKey($destinationKey)) {
        $ports[$destinationKey].ReceivedBytes += $bytes
        $ports[$destinationKey].Packets++
    }
}

$results = $ports.Values | Sort-Object Protocol, Port | ForEach-Object {
    [pscustomobject]@{
        Protocol = $_.Protocol
        Port = $_.Port
        PID = $_.PID
        'Service / Process' = $_.Service
        'Received (bytes)' = $_.ReceivedBytes
        'Sent (bytes)' = $_.SentBytes
        'Received (B/s)' = [math]::Round($_.ReceivedBytes / $IntervalSeconds, 2)
        'Sent (B/s)' = [math]::Round($_.SentBytes / $IntervalSeconds, 2)
        Packets = $_.Packets
    }
}

$results | Format-Table -AutoSize

Write-Host "`nNote: byte totals are captured frame bytes (including link-layer overhead where available)." -ForegroundColor DarkGray
