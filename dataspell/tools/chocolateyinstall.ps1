$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Workaround for https://youtrack.jetbrains.com/issue/IDEA-202935
$programFiles = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]
$pp = Get-PackageParameters

$installDir = "$programFiles\JetBrains\DataSpell $env:ChocolateyPackageVersion"
if ($pp.InstallDir) {
    $installDir = $pp.InstallDir
}

$silentArgs   = "/S /CONFIG=$toolsDir\silent.config "
$silentArgs   += "/D=`"$installDir`""

$packageArgs = @{
  packageName   = 'DataSpell'
  unzipLocation = $toolsDir
  fileType      = 'exe' #only one of these: exe, msi, msu
  url           = 'https://download.jetbrains.com/python/dataspell-2023.2.5.exe'

  softwareName  = 'DataSpell*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  checksum      = 'e7b904af8e2584fb5d5a114f8bbc6a43061e0d581ce31247b6ac79cedde2a73b'
  checksumType  = 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage
