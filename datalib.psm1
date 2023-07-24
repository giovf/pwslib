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
}

this 
function getkeyvals {
    param (
        [string]$filePath,
        [string]$targetKey,
        [string]$targetValue
    )

    # Read JSON data from the specified file
    $jsonData = Get-Content -Path $filePath -Raw

    # Convert JSON data to a PowerShell object
    $array = $jsonData | ConvertFrom-Json

    # Filter the objects based on the target key-value pair and return the corresponding array
    $resultArray = @()

    foreach ($item in $array) {
        if ($item.$targetKey -eq $targetValue) {
            $resultArray = $item.SummaryFields
            break
        }
    }

    return $resultArray
}