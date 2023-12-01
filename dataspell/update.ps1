Import-Module AU
$releases = 'https://data.services.jetbrains.com/products/releases?code=DS&latest=true&type=release'

function global:au_SearchReplace {
    return @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.Url32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_GetLatest {
    $json = Invoke-WebRequest $releases | ConvertFrom-Json
    $url = $json.DS.downloads.windows.link
    $version = $json.DS.version
    $checksum = ((Invoke-RestMethod -Uri $json.DS.downloads.windows.checksumLink -UseBasicParsing).Split(" "))[0]

    $Latest = @{ Url32 = $url; Version = $version; Checksum32 = $checksum; ChecksumType32 = 'sha256' }
    return $Latest
}

update -ChecksumFor none