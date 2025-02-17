$subnet = Read-Host "Enter the subnet (e.g.: "10.0.10")"

$scriptBlock = {
    param($ip)
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        return "$ip is ONLINE"
    } else {
        return "$ip is OFFLINE"
    }
}

$runspaces = @()

1..254 | ForEach-Object {
    $ip = "$subnet.$_"
    
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()

    $runspaceThread = [powershell]::Create().AddScript($scriptBlock).AddArgument($ip)
    $runspaceThread.Runspace = $runspace
    $asyncResult = $runspaceThread.BeginInvoke()

    $runspaces += [PSCustomObject]@{ Runspace = $runspace; Thread = $runspaceThread; AsyncResult = $asyncResult }
}

$runspaces | ForEach-Object {
    $result = $_.Thread.EndInvoke($_.AsyncResult)
    
    if ($result -match "ONLINE") {
        Write-Host $result -ForegroundColor Green
    } elseif ($result -match "OFFLINE") {
        Write-Host $result -ForegroundColor Red
    }
}
