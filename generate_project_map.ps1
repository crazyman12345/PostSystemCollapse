$Root = Get-Location
$ScriptsRoot = Join-Path $Root "scripts"
$Output = Join-Path $Root "PROJECT_MAP.md"

"# IdleGame Project Map" | Set-Content $Output
"" | Add-Content $Output
"Compact index of project GML code. Use this to locate files before searching the project." | Add-Content $Output
"" | Add-Content $Output

# ==========================================
# ONLY ACTUAL PROJECT SCRIPTS
# ==========================================

$Files = Get-ChildItem $ScriptsRoot -Recurse -Filter *.gml |
    Sort-Object FullName

# ==========================================
# FUNCTIONS BY FILE
# ==========================================

"## Scripts and Functions" | Add-Content $Output
"" | Add-Content $Output

$FunctionCount = 0

foreach ($File in $Files)
{
    $Relative = $File.FullName.Substring($Root.Path.Length + 1)
    $Content = Get-Content $File.FullName

    $Functions = @()

    foreach ($Line in $Content)
    {
        if ($Line -match '^\s*function\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(')
        {
            $Functions += $Matches[1]
        }
    }

    if ($Functions.Count -gt 0)
    {
        $UniqueFunctions = $Functions | Sort-Object -Unique

        "### $Relative" | Add-Content $Output

        foreach ($Function in $UniqueFunctions)
        {
            "- $Function" | Add-Content $Output
            $FunctionCount++
        }

        "" | Add-Content $Output
    }
}

# ==========================================
# ENUMS
# ==========================================

"## Enums" | Add-Content $Output
"" | Add-Content $Output

$EnumNames = @()

foreach ($File in $Files)
{
    foreach ($Line in (Get-Content $File.FullName))
    {
        if ($Line -match '^\s*enum\s+([A-Za-z_][A-Za-z0-9_]*)')
        {
            $Name = $Matches[1]

            if ($Name -notlike "e__*")
            {
                $EnumNames += $Name
            }
        }
    }
}

$EnumNames = $EnumNames | Sort-Object -Unique

foreach ($EnumName in $EnumNames)
{
    "- $EnumName" | Add-Content $Output
}

"" | Add-Content $Output

# ==========================================
# GLOBALS
# ==========================================

"## Globals" | Add-Content $Output
"" | Add-Content $Output

$GlobalNames = @()

foreach ($File in $Files)
{
    $Content = Get-Content $File.FullName -Raw

    foreach ($Match in [regex]::Matches(
        $Content,
        'global\.([A-Za-z_][A-Za-z0-9_]*)'
    ))
    {
        $Name = $Match.Groups[1].Value

        if ($Name -notlike "__*")
        {
            $GlobalNames += $Name
        }
    }
}

$GlobalNames = $GlobalNames | Sort-Object -Unique

foreach ($GlobalName in $GlobalNames)
{
    "- global.$GlobalName" | Add-Content $Output
}

# ==========================================
# DONE
# ==========================================

Write-Host ""
Write-Host "PROJECT_MAP.md generated."
Write-Host "Scripts scanned: $($Files.Count)"
Write-Host "Functions indexed: $FunctionCount"
Write-Host "Enums indexed: $($EnumNames.Count)"
Write-Host "Globals indexed: $($GlobalNames.Count)"
Write-Host ""