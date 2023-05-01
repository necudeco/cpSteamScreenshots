
$src = $args[0];
$dest = $args[1];

if ( Test-Path -Path $src ){
  
}else{
  Write-Host "Bad SRC $src"
  Write-Host ".\cpSteamScreenShots.ps1 <DIR STEAM>  <DIR Mis Imagenes>"
  Write-Host ".\cpSteamScreenShots.ps1  c:\Steam\userdata\128290065\760\remote\" "C:\Users\Usuario\Pictures\Steam\"
  exit
}

if ( Test-Path -Path $dest ){
  
}else{
  Write-Host "Bad DEST $dest"
  Write-Host ".\cpSteamScreenShots.ps1 <DIR STEAM>  <DIR Mis Imagenes>"
  Write-Host ".\cpSteamScreenShots.ps1  c:\Steam\userdata\128290065\760\remote\" "C:\Users\Usuario\Pictures\Steam\"
  exit
}

exit

$watcher = New-Object System.IO.FileSystemWatcher 
$watcher.Path = $src
$watcher.Filter = "*.jpg"
$watcher.IncludeSubdirectories = $true  
$watcher.EnableRaisingEvents = $true  

$action = { 
    $path = $Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
    
    if ( $name.Contains("thumbnails") ){

    }else{
      Write-Host "new big file detected $name"
      Write-Host "FullPath $path"
      Copy-Item $path -Destination $dest
    }
    
  }    

Write-Host "Starting"


$sourceId = New-Guid
Register-ObjectEvent $watcher "Created" -Action $action -SourceIdentifier $sourceId

while ( $true ){

  $event = Wait-Event -SourceIdentifier $sourceId
  $event | Remove-Event

  $eventDetails = $event.SourceArgs[1]
  $eventDetails | Out-Host

}

Write-Host "Finishing"

Unregister-Event -SourceIdentifier $sourceId
$watcher.Dispose()
  
