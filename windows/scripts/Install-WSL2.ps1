Write-Host "Install WSL2"

try {
	wsl --install
}
catch [System.Exception] {
	Write-Warning -Message $_.Exception.Message
}
