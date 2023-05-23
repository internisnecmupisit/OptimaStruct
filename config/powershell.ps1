$loginserver = "__loginserver__"

$username = "__username__"

$password = "__password__"

Write-Host "##vso[task.setvariable variable=username]$username"

Write-Host "##vso[task.setvariable variable=password]$password"

Write-Host "##vso[task.setvariable variable=loginserver]$loginserver"