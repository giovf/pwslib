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

function Get-Keyvals {
    param (
        [string]$filePath,
        [string]$targetKey
    )

    # Read JSON data from the specified file
    $jsonData = Get-Content -Path $filePath -Raw

    # Convert JSON data to a PowerShell object
    $data = $jsonData | ConvertFrom-Json

    # Initialize an empty array to store the found values
    $resultArray = @()

    # Recursive function to search through the JSON data
    function SearchData($item) {
        if ($item -is [array]) {
            foreach ($element in $item) {
                SearchData $element
            }
        } elseif ($item -is [hashtable]) {
            foreach ($key in $item.Keys) {
                if ($key -eq $targetKey) {
                    $resultArray += $item.$key
                } else {
                    SearchData $item.$key
                }
            }
        }
    }

    # Start searching through the JSON data
    SearchData $data

    return $resultArray
}
