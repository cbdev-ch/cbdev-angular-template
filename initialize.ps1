Set-StrictMode -Version latest

if ($args.Count -cge 0) {
    $name = $args[0]

    $templateLocation = Get-Location
    $githubWorkspace = "$templateLocation\..\"
    $projectLocation = "$githubWorkspace$name"

    Write-Host "Generating Angular project..."

    $createAngularProject = Start-Job -ScriptBlock { Start-Process -FilePath ng.cmd -ArgumentList "new", $name, "--defaults=true" -WorkingDirectory $githubWorkspace }
    
    while (!$createAngularProject.Finished) {
        Start-Sleep -Seconds 1
    }

    Write-Host "Copying template files..."

    Move-Item -Path "$templateLocation\src\app" -Destination "$projectLocation\src\app" -Exclude "app.component.ts", "app.component.specs.ts"

    Write-Host "Finished"

} else {
    Write-Error -Message "Name argument missing"
}