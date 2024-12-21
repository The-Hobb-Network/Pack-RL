#
# Minecraft Texure Pack (THN RL) - Automatic check and installation
# Author: C.M.R. Beute
# Version: v0.7 - 21-12-2024 00:57
#

#
# ReadMe:
# ! It's important to keep your GitHub token safe
# ! Without a token, this script will be more limited
# ! Change the Paths and other variables conform your own wishes





# Define variables
$owner = "The-Hobb-Network"
$repo = "Pack-RL"
$url = "https://api.github.com/repos/$owner/$repo/commits/main"
$filePath = "<Path\for\saving\commitid\latestCommitID.txt"
$resourcePackPath = "<Path\To\Resourcepacks\Folder>"
# GitHub Personal Access Token (replace with your actual token)
$token = "<put token here>"

# Create logs directory if it doesn't exist
$logDir = "$resourcePackPath\logs"
if (-Not (Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

# Limit logs to 50 files
$logFiles = Get-ChildItem -Path $logDir -Filter *.json | Sort-Object LastWriteTime
if ($logFiles.Count -ge 50) {
    Remove-Item -Path $logFiles[0].FullName -Force
}

# Generate log file name with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFilePath = "$logDir\update_log_$timestamp.json"

# Function to log messages
function Write-Log {
    param ([string]$status, [string]$message)
    $logEntry = [PSCustomObject]@{
        Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        Status    = $status
        Message   = $message
    }
    $logEntry | ConvertTo-Json -Compress | Out-File -FilePath $logFilePath -Append
}

try {
    # Log start
    Write-Log -Status "Info" -Message "Update check started."

    # Get the latest commit ID from GitHub with authentication
    $headers = @{ Authorization = "token $token"; "User-Agent" = "PowerShell" }
    $response = Invoke-WebRequest -Uri $url -Headers $headers

    # Check remaining rate limit
    $rateLimitRemaining = $response.Headers["X-RateLimit-Remaining"]
    Write-Log -Status "Info" -Message "Rate limit remaining: $rateLimitRemaining"

    # Parse JSON response body to extract commit ID
    $responseBody = $response.Content | ConvertFrom-Json
    $latestCommitId = $responseBody.sha

    # Check if the commit ID file exists
    if (Test-Path -Path $filePath) {
        # Read the stored commit ID
        $storedCommitId = Get-Content -Path $filePath
    } else {
        # Initialize if the file does not exist
        $storedCommitId = ""
        Write-Log -Status "Info" -Message "No previous commit ID found. Assuming first-time setup."
    }

    # Compare commit IDs
    if ($latestCommitId -eq $storedCommitId) {
        Write-Host "No new updates found."
        Write-Log -Status "Info" -Message "No new updates found."
    } else {
        # New update detected
        Write-Host "New update detected. Downloading and installing..."
        Write-Log -Status "Info" -Message "New update detected. Downloading and installing."

        # Example download and extraction process (update URL as needed)
        $downloadUrl = "https://github.com/$owner/$repo/archive/refs/heads/main.zip"
        $tempZipPath = "$resourcePackPath\Pack-RL.zip"

        # Download the latest resource pack
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZipPath
        Write-Log -Status "Info" -Message "Downloaded resource pack to $tempZipPath."

        # Extract the zip file
        Expand-Archive -Path $tempZipPath -DestinationPath $resourcePackPath -Force
        Write-Log -Status "Info" -Message "Extracted resource pack."

        # Update stored commit ID
        $latestCommitId | Out-File -FilePath $filePath -Force
        Write-Log -Status "Info" -Message "Updated commit ID stored in $filePath."

        # Cleanup
        Remove-Item -Path $tempZipPath -Force
        Write-Log -Status "Info" -Message "Temporary files cleaned up."
    }

} catch {
    # Handle errors
    $errorMessage = $_.Exception.Message
    Write-Host "An error occurred: $errorMessage"
    Write-Log -Status "Error" -Message $errorMessage
} finally {
    # Log end
    Write-Log -Status "Info" -Message "Update check completed."
}
