# Define the path to the JSON file that will store the bookmarks
$bookmarkFile = "$HOME\bookmarks.json"

# Ensure the bookmark file exists
if (!(Test-Path -Path $bookmarkFile)) {
    @{} | ConvertTo-Json | Set-Content -Path $bookmarkFile
}

function gt {
    param (
        [string]$command,
        [string]$name
    )

    # Load the bookmarks from the JSON file
    $bookmarks = Get-Content -Path $bookmarkFile | ConvertFrom-Json

    switch ($command) {
        "mark" {
            # Add the current directory as a bookmark
            if (!$bookmarks.$name) {
                $bookmarks | Add-Member -NotePropertyName $name -NotePropertyValue (Get-Location).Path
            } else {
                $bookmarks.$name = (Get-Location).Path
            }
            $bookmarks | ConvertTo-Json | Set-Content -Path $bookmarkFile
        }
        "remove" {
            # Remove the bookmark
            if ($bookmarks.$name) {
                $bookmarks.PSObject.Properties.Remove($name)
                $bookmarks | ConvertTo-Json | Set-Content -Path $bookmarkFile
            } else {
                Write-Host "Bookmark '$name' does not exist."
            }
        }
        default {
            # If no command is specified, change to the directory of the bookmark
            if ($bookmarks.$command) {
                Set-Location -Path $bookmarks.$command
            } else {
                # If the bookmark doesn't exist, open fzf to select a bookmark
                $selectedBookmark = $bookmarks.PSObject.Properties.Name | fzf
                if ($selectedBookmark) {
                    Set-Location -Path $bookmarks.$selectedBookmark
                }
            }
        }
    }
}

function fcd {
    try {
        $item = Get-Item $(fzf)
        if ($null -ne $item) {
            if ($item.PSIsContainer) {
                Set-Location $item.FullName
            } else {
                $selection = $item.FullName
                if ($selection) {
                    nvim $selection
                }
            }
        }
    } catch {}
}
