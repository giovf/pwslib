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

function Get-ArrayVals {
    param (
        [Parameter(Mandatory = $true)]
        [string]$path,
        [Parameter(Mandatory = $true)]
        [string]$targetvalue,
        [Parameter(Mandatory = $false)]
        [string]$targetdata
    )
  
    # Convert the JSON string to PowerShell objects
    $jsonArray = Get-Content -Path $path -Raw
    $jsonObjects = ConvertFrom-Json $jsonArray
  
    # Define a function to search for the target key recursively
    function Get-ValueRecursively ($obj) {
        $result = @()
        foreach ($property in $obj.PSObject.Properties) {
            if ($property.Value -is [System.Array]) {
                # If the value is an array object, search for the target key recursively
                foreach ($item in $property.Value) {
                    $result += Get-ValueRecursively $item
                }
            }
             elseif ($property.Name -eq "Type" -and $property.Value -eq $targetvalue) {
                # If the key is "Type" and value is "INVOICE_RECEIPT_ID", extract the "Value"
                $result += $obj.Value
            }
        }
        return $result
    }
  
    # Loop through each object in the array and extract the data with "Type": "INVOICE_RECEIPT_ID"
    $invoiceReceiptIDs = @()
    foreach ($obj in $jsonObjects) {
        $invoiceReceiptIDs += Get-ValueRecursively $obj
    }
  
    # Output the extracted INVOICE_RECEIPT_ID values
    return $invoiceReceiptIDs
  }
