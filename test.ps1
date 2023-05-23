$webapps = az webapp list --resource-group rg-cv-prod --query "[?hostingEnvironmentProfile == null].{Name:name, DefaultHostName:defaultHostName}" --output tsv

foreach ($webapp in $webapps -split "`n") {
    $name, $defaultHostName = $webapp -split "`t"
    $value = "https://$defaultHostName"
    Write-Host "##vso[task.setvariable variable=$name]$value"
}