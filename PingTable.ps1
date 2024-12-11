param (
[string[]]$Addresses = @("1.1.1.1", "localhost"),
[bool]$WriteToFile = $true,
[string]$ResultDirectory = ".\Results",
[int]$SleepTime = 5
)

$cmd = {
    param($Address, $WriteToFile, $ResultDirectory)

    function Test-Address {
    param (
        [string]$Address
    )

    $Date = Get-Date
    $Test = Test-NetConnection $Address
    $Result = @{"Address"=$Address; "Date"=$Date; "Success"=$Test.PingSucceeded; "ReplyTime"=$Test.PingReplyDetails.RoundTripTime}
    $Result
    }

    $Result = Test-Address $Address
    $ResultOutput = "$($Result.Date), $($Result.Success), $($Result.ReplyTime), $($Result.Address)"
    if ($WriteToFile) {
        $WriteLocation = Join-Path -Path $ResultDirectory -ChildPath "$Address.csv"
        $ResultOutput >> $WriteLocation
    } else {
        $ResultOutput
    }
}

if (-not (Test-Path -Path $ResultDirectory) -and $WriteToFile) {
    New-Item -Path $ResultDirectory -ItemType Directory
}

while (1) {
    # Clean up old jobs
    Get-Job | Where-Object { $_.State -eq 'Completed' } | Remove-Job

    foreach ($Address in $Addresses) {
        Start-Job -ScriptBlock $cmd -ArgumentList $Address, $WriteToFile, $ResultDirectory -Name $Address > $null
    }
    # Wait for all jobs to finish
    #Get-Job | Wait-Job > $null
    if (-not($WriteToFile)) {
        foreach ($job in Get-Job) {
            $output = Receive-Job -Job $job
            if ($output) {
                $output | Format-Table -AutoSize
            }
        }
    }
    Start-Sleep -Seconds $SleepTime
}
