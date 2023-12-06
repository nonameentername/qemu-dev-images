Write-Host "Install Microsoft-Hyper-V, Containers"

try {
	Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V", "Containers") -NoRestart -All
}
catch [System.Exception] {
	Write-Warning -Message $_.Exception.Message
}
