$rgterraform = "rg-"+$(projectname)+"-"+$(environment)

$acrname = "acr"+$(projectname)+$(environment)

Write-Host "##vso[task.setvariable variable=rgterraform]$rgterraform"

Write-Host "##vso[task.setvariable variable=acrname]$acrname"