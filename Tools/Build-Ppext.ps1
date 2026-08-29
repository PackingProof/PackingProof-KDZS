[CmdletBinding()]
param(
    [string]$OutputDirectory = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$authorManifestPath = Join-Path $repositoryRoot "manifest.json"
$authorManifest = Get-Content -Raw -Encoding UTF8 -LiteralPath $authorManifestPath | ConvertFrom-Json
$version = [string]$authorManifest.version
if ($version -notmatch '^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$') {
    throw "用户脚本版本必须是 X.Y：$version"
}

$payloadRelativePath = ([string]$authorManifest.payload).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
$payloadPath = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot $payloadRelativePath))
$repositoryPrefix = $repositoryRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
if (-not $payloadPath.StartsWith($repositoryPrefix, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $payloadPath)) {
    throw "payload 路径无效：$payloadPath"
}

$script = [System.IO.File]::ReadAllText($payloadPath, [System.Text.Encoding]::UTF8)
$versionMatch = [System.Text.RegularExpressions.Regex]::Match($script, '(?m)^//\s*@version\s+(?<version>[^\r\n]+)\r?$')
if (-not $versionMatch.Success -or $versionMatch.Groups['version'].Value.Trim() -ne $version) {
    throw "脚本 @version 必须与 manifest.json 一致"
}

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $repositoryRoot "Release"
}
$outputRoot = [System.IO.Path]::GetFullPath($OutputDirectory)
[System.IO.Directory]::CreateDirectory($outputRoot) | Out-Null
$outputPath = Join-Path $outputRoot ("packingproof.kdzs-$version.ppext")
if (Test-Path -LiteralPath $outputPath) {
    throw "发布文件已经存在，请先确认并移走旧文件：$outputPath"
}

$workingDirectory = Join-Path $outputRoot (".ppext-build-" + [Guid]::NewGuid().ToString("N"))
$workingPrefix = $outputRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
try {
    $packagePayloadDirectory = Join-Path $workingDirectory "payload"
    [System.IO.Directory]::CreateDirectory($packagePayloadDirectory) | Out-Null
    [System.IO.File]::Copy($payloadPath, (Join-Path $packagePayloadDirectory (Split-Path $payloadPath -Leaf)), $false)
    [System.IO.File]::Copy((Join-Path $repositoryRoot "README.md"), (Join-Path $workingDirectory "README.md"), $false)
    [System.IO.File]::Copy((Join-Path $repositoryRoot "LICENSE"), (Join-Path $workingDirectory "LICENSE"), $false)

    $packageManifest = [ordered]@{
        schemaVersion = 1
        format = "packingproof-extension"
        packageFormatVersion = 1
        id = [string]$authorManifest.id
        version = $version
        type = "userscript"
        installation = [ordered]@{
            mode = "userscript-import"
            payloadPath = "payload/" + (Split-Path $payloadPath -Leaf)
        }
        compatibility = [ordered]@{
            minPackingProofVersion = [string]$authorManifest.minPackingProofVersion
            platforms = [ordered]@{
                userscript = @("any")
            }
        }
        access = [ordered]@{
            packingProofPermissions = @()
            packingProofCapabilities = @()
            systemAccess = @()
        }
    }
    $manifestJson = $packageManifest | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText(
        (Join-Path $workingDirectory "manifest.json"),
        $manifestJson + "`n",
        [System.Text.UTF8Encoding]::new($false))

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory(
        $workingDirectory,
        $outputPath,
        [System.IO.Compression.CompressionLevel]::Optimal,
        $false)
    Write-Host "已生成：$outputPath"
}
finally {
    if (Test-Path -LiteralPath $workingDirectory) {
        $resolvedWorkingDirectory = [System.IO.Path]::GetFullPath($workingDirectory)
        if (-not $resolvedWorkingDirectory.StartsWith($workingPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "临时目录超出输出目录：$resolvedWorkingDirectory"
        }
        Remove-Item -LiteralPath $workingDirectory -Recurse -Force
    }
}
