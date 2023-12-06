Write-Host "Install Docker"

$DockerZip = Join-Path $Env:Temp docker.zip
Invoke-WebRequest https://download.docker.com/win/static/stable/x86_64/docker-24.0.7.zip -OutFile $DockerZip

$DockerInstaller = Join-Path $Env:Temp InstallDocker.msi
Expand-Archive -LiteralPath $DockerZip -DestinationPath "C:\Program Files"

$instScriptUrl = "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1"
$instScriptPath = Join-Path $Env:Temp install-docker.ps1
Invoke-WebRequest $instScriptUrl -OutFile $instScriptPath

$dockerPath = "$env:TEMP\docker"

$Path = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $dockerPath
[Environment]::SetEnvironmentVariable( "Path", $Path, "Machine" )
