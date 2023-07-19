function Get-CurrentTime {
    return Get-Date
}

function Get-SquaredNumber {
    param (
        [int]$Number
    )
    return $Number * $Number
}