param (
[string[]]$Addresses = @("1.1.1.1", "localhost"),
[bool]$WriteToFile = $true,
[string]$ResultDirectory = ".\Results",
[int]$SleepTime = 5
)

function Test-Address {
    param (
        [string]$Address
    )

    $Date = Get-Date
    $Test = Test-NetConnection $Address
    $Result = @{"Address"=$Address; "Date"=$Date; "Success"=$Test.PingSucceeded; "ReplyTime"=$Test.PingReplyDetails.RoundTripTime}
    $Result
}

if (-not (Test-Path -Path $ResultDirectory) -and $WriteToFile) {
    New-Item -Path $ResultDirectory -ItemType Directory
}

while (1) {
    foreach ($Address in $Addresses) {
        $Result = Test-Address $Address
        if ($WriteToFile) {
            $WriteLocation = Join-Path -Path $ResultDirectory -ChildPath "$Address.csv"
            $Result | ConvertTo-CSv -NoHeader >> $WriteLocation
        } else {
            $Result | ConvertTo-CSv -NoHeader
        }
    }
    Start-Sleep -Seconds $SleepTime
}
