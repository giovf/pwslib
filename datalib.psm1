function Get-CurrentTime {
    return Get-Date
}

function Get-SquaredNumber {
    param (
        [int]$Number
    )
    return $Number * $Number
}

function Convert-DateFormat {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Date
    )
    
	$formats = @("dd-MM-yyyy", "dd/MM/yyyy", "MM/dd/yyyy", "dd'th' MMMM yyyy", "dd MMMM yyyy", "d/M/yy", "d MMM yyyy")

    foreach ($format in $formats) {
        try {
            $parsedDate = [DateTime]::ParseExact($Date, $format, [CultureInfo]::InvariantCulture)
            return $parsedDate.ToString("dd/MM/yyyy")
        }
        catch {
            continue
        }
    }

$originalDate = $args[0]
$convertedDate = Convert-DateFormat -Date $originalDate
Write-Host "Converted date: $convertedDate"

Set-Clipboard -Value ($convertedDate)

$windowTitle = "Completed"
[Console]::Title = $windowTitle

}

