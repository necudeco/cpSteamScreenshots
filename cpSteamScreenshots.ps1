
$src = $args[0];
$dest = $args[1];

if ( Test-Path -Path $src ){

}else{
  Write-Host ".\cpSteamScreenShots.ps1 <DIR STEAM>  <DIR Mis Imagenes>"
  Write-Host ".\cpSteamScreenShots.ps1  c:\Steam\userdata\128290065\760\remote\" "C:\Users\Usuario\Pictures\Steam\"
  exit
}

if ( Test-Path -Path $dest ){

}else{
  Write-Host ".\cpSteamScreenShots.ps1 <DIR STEAM>  <DIR Mis Imagenes>"
  Write-Host ".\cpSteamScreenShots.ps1  c:\Steam\userdata\128290065\760\remote\" "C:\Users\Usuario\Pictures\Steam\"
  exit
}

Write-Host "cpSteamScreenshots.ps1 $src $dest"

$watcher = New-Object System.IO.FileSystemWatcher 
$watcher.Path = $src
$watcher.Filter = "*.jpg"
$watcher.IncludeSubdirectories = $true  
$watcher.EnableRaisingEvents = $true  

$action = { 
    $path = $Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
    $dest2 = $Event.MessageData
    
    $startTime = Get-Date

    if ( $name.Contains("thumbnails") ){

    }else{
      Write-Host " "
      Write-Host "new big file detected $name $startTime"
      Write-Host "Copy $path $dest2 "
      
      Copy-Item -Path $path -Destination $dest2 -Force

      Write-Host "File copied "
      #robocopy $path $dest2
    }
    
  }    

$sourceId = New-Guid

Write-Host "Starting $sourceId"



Register-ObjectEvent $watcher "Created" -Action $action -SourceIdentifier $sourceId  -MessageData $dest

while ( $true ){

  $event = Wait-Event -SourceIdentifier $sourceId
  $event | Remove-Event

  $eventDetails = $event.SourceArgs[1]
  $eventDetails | Out-Host

}

Write-Host "Finishing"

Unregister-Event -SourceIdentifier $sourceId
$watcher.Dispose()
  
