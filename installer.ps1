
$path = "C:\Windows\Temp\Softwares\tools\"
$softwares = Import-Csv "C:\Users\admin\Desktop\automation\aplications.csv" -Delimiter "," -Header 'Installer' , 'Switch' , 'Link' | Select-Object Installer,Switch,Link
Write-Output $softwares

foreach($link in $softwares){
    $url = $link.Link
    $url = $url.ToString()
    $filename = $link.Installer
    $filename = $filename.ToString()
    Write-Output $url
    mkdir C:\Windows\Temp\Softwares\tools -Force
    #$dir = 'C:\Windows\Temp\Softwares\tools\'
    Write-Host "Downloading $url"
    Write-Output "filename" $filename
    $dlPath = $path + $filename
    Write-Output "dlpath" $dlPath
    Write-Output "link" $url
    Invoke-WebRequest $url -OutFile $dlPath
}
    
foreach($software in $softwares){

    $softexec = $software.Installer
    $softexec = $softexec.ToString()
    Write-Output $softexec

    $pkgs = Get-ChildItem $path$softexec | Where-Object {$_.Name -eq $softexec}


    foreach($pkg in $pkgs){

        $ext = [System.IO.Path]::GetExtension($pkg)
        $ext = $ext.ToLower()

        $switch = $software.Switch
        $switch = $switch.ToString()
        Write-Output $switch

        if($ext -eq ".msi"){
        mkdir C:\Windows\Temp\Softwares -Force
        Copy-Item "$path$softexec" -Recurse C:\Windows\Temp\Softwares -Force
        Write-Host "Installing $softexec silently, Please wait...." -BackgroundColor Yellow
        Start-Process "C:\Windows\Temp\Softwares\$softexec" -ArgumentList "$switch" -Wait

        Remove-Item "C:\Windows\Temp\Softwares\$softexec" -Recurse -Force
        Write-Host "Installation of $softexec completed" -BackgroundColor Green
         }
        else {
        
        mkdir C:\Windows\Temp\Softwares -Force
        Copy-Item "$path$softexec" -Recurse C:\Windows\Temp\Softwares -Force
        Write-Host "Installing $softexec silently, Please wait...." -BackgroundColor Yellow
        Start-Process "C:\Windows\Temp\Softwares\$softexec" -ArgumentList "$switch" -Wait -NoNewWindow

        Remove-Item "C:\Windows\Temp\Softwares\$softexec" -Recurse -Force
        Write-Host "Installation of $softexec completed" -BackgroundColor Green
       
                   
        }
    }

}