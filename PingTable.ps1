$Addresses = @("1.1.1.1", "localhost")
$WriteToFile = $true
$ResultDirectory = ".\Results"

function Test-Address {
    param (
        [string]$Address
    )

    $Date = Get-Date
    $Test = Test-NetConnection $Address
    $Result = @{"Address"=$Address; "Date"=$Date; "Success"=$Test.PingSucceeded; "ReplyTime"=$Test.PingReplyDetails.RoundTripTime}
    $Result
}

while (1) {
    foreach ($Address in $Addresses) {
        $Result = Test-Address $Address
        $WriteLocation = Join-Path -Path $ResultDirectory -ChildPath $Address
        $Result | ConvertTo-CSv -NoHeader >> $WriteLocation
    }
}
