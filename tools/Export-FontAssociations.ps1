# tools/Export-FontAssociations.ps1
# Generate machine-specific registry imports without changing font associations.
param([string]$OutputDirectory = (Join-Path $PSScriptRoot '../.cache/font-associations'))
$ErrorActionPreference = 'Stop'
Add-Type @'
using System.Runtime.InteropServices;
public static class FoundryRegistryNative {
    [DllImport("kernel32.dll")] public static extern uint GetACP();
}
'@
function Quote-Reg([string]$Text) { '"' + $Text.Replace('\', '\\').Replace('"', '\"') + '"' }
function Format-Value([string]$Name, $Value, [string]$Kind) {
    $prefix = (Quote-Reg $Name) + '='
    if ($Kind -eq 'Absent') { return $prefix + '-' }
    if ($Kind -eq 'String') { return $prefix + (Quote-Reg ([string]$Value)) }
    if ($Kind -eq 'MultiString') {
        $bytes = [Text.Encoding]::Unicode.GetBytes(($Value -join "`0") + "`0`0")
        return $prefix + 'hex(7):' + (($bytes | ForEach-Object { $_.ToString('x2') }) -join ',')
    }
    throw "Unsupported registry value kind: $Kind"
}
$machine = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', 'Registry64')
$user = [Microsoft.Win32.RegistryKey]::OpenBaseKey('CurrentUser', 'Registry64')
$linkPath = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink'
$acp = [FoundryRegistryNative]::GetACP()
$eudcPath = "EUDC\$acp"
$sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$font = Join-Path $env:WINDIR 'Fonts\Foundry-ShiftedBinaryFallback.ttf'
$entry = 'Foundry-ShiftedBinaryFallback.ttf,Foundry Shifted binary Fallback'
$header = "Windows Registry Editor Version 5.00`r`n`r`n; Generated for this computer and user. Import before other font-association changes.`r`n"
$update = $header
$restore = $header
try {
    foreach ($spec in @(
        @{ Root=$machine; Path=$linkPath; RegPath="HKEY_LOCAL_MACHINE\$linkPath"; Names=@('Microsoft Sans Serif','MS Shell Dlg') },
        @{ Root=$user; Path=$eudcPath; RegPath="HKEY_USERS\$sid\$eudcPath"; Names=@('SystemDefaultEUDCFont') }
    )) {
        $key = $spec.Root.OpenSubKey($spec.Path)
        try {
            $update += "`r`n[$($spec.RegPath)]`r`n"
            $restore += "`r`n[$($spec.RegPath)]`r`n"
            foreach ($name in $spec.Names) {
                $exists = $null -ne $key -and $key.GetValueNames() -contains $name
                $kind = if ($exists) { $key.GetValueKind($name).ToString() } else { 'Absent' }
                $value = if ($exists) { $key.GetValue($name, $null, 'DoNotExpandEnvironmentNames') } else { $null }
                $restore += (Format-Value $name $value $kind) + "`r`n"
                if ($name -eq 'SystemDefaultEUDCFont') {
                    if ($exists -and ($kind -ne 'String' -or [IO.Path]::GetFileName($value) -notmatch '^(Foundry-ShiftedBinaryFallback|ShiftedBinaryLink|ShiftedByteLink)\.ttf$')) {
                        throw 'Another private-use font is already associated. No files written; preserve that association.'
                    }
                    $update += (Format-Value $name $font 'String') + "`r`n"
                } else {
                    if ($exists -and $kind -ne 'MultiString') { throw "Unexpected registry kind for $name" }
                    $retained = @($value | Where-Object { $_ -and $_ -notmatch '^(Foundry-ShiftedBinaryFallback\.ttf|ShiftedBinary(?:Link|GDI)?\.(?:ttf|otf)|ShiftedByte(?:Link|GDI)?\.(?:ttf|otf)),' })
                    $update += (Format-Value $name (@($entry) + $retained) 'MultiString') + "`r`n"
                }
            }
        } finally { if ($key) { $key.Dispose() } }
    }
} finally { $machine.Dispose(); $user.Dispose() }
$directory = [IO.Path]::GetFullPath($OutputDirectory)
[IO.Directory]::CreateDirectory($directory) | Out-Null
foreach ($file in @('Install-Foundry-fallback.reg','Restore-font-associations.reg')) {
    if (Test-Path (Join-Path $directory $file)) { throw "Existing ${file}: use a fresh output directory to preserve its snapshot." }
}
[IO.File]::WriteAllText((Join-Path $directory 'Install-Foundry-fallback.reg'), $update, [Text.Encoding]::Unicode)
[IO.File]::WriteAllText((Join-Path $directory 'Restore-font-associations.reg'), $restore, [Text.Encoding]::Unicode)
Write-Output "Created update and restore files in $directory. Registry unchanged. System ANSI code page: $acp."
if (-not (Test-Path $font)) { Write-Output "Before importing, install Foundry Shifted binary Fallback for all users: $font" }
