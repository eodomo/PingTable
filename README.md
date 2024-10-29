# Overview
Run continuous pings and save results to a CSV!

# Usage
## Arguments
- Addresses = Array of IP + DNS addresses to ping (Default = "1.1.1.1","localhost")
- WriteToFile = Boolean of whether results should be saved to file or pasted to the console (Default = $true)
- ResultDirectory = Directory where result files should be saved (Default = ".\Results")
- SleepTime = Seconds to wait before ping attempts (Default = 5)

## Examples
Ping Google every 5 seconds:

	.\PingTable.ps1 -Addresses "google.com"

Ping localhost, 1.1.1.1, and google.com as fast as possible without saving to file

	.\PingTable.ps1 -Addresses "localhost","1.1.1.1","google.com" -WriteToFile $false -SleepTime 0
