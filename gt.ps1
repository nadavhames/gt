# Hashtable to store mappings of words to locations
$script:LocationMappings = @{
    "dev" = "C:\dev"
    # Add more shortcuts as needed
}

# Function to quickly change to predefined directories with autocomplete
function GoTo {
    param (
        [string]$Location,
        [switch]$List  # -list prints script:locationmappings
    )

    if ($List) {
        # Print the mappings to the console
        $script:LocationMappings | Format-Table -AutoSize
    } elseif (-not $Location)  {
        #select a location using fzf
        $selectedLocation = $script:LocationMappings.Keys | fzf --ansi
        if ($selectedLocation) {
            Set-Location $script:LocationMappings[$selectedLocation]
        }
    } elseif ($script:LocationMappings.ContainsKey($Location)) {
        Set-Location $script:LocationMappings[$Location]
    } else {
        Write-Host "Unknown location. Available options: $($script:LocationMappings.Keys -join ", ") "
    }
}

# Define the argument completer for the GoTo function using the mappings
Register-ArgumentCompleter -CommandName GoTo -ParameterName Location -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    if ($wordToComplete) {
        $script:LocationMappings.Keys -like "$wordToComplete*"
    } else {
        $script:LocationMappings.Keys
    }
}
