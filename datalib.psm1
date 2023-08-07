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

function Get-Array_Vals{
    param (
        [Parameter(Mandatory = $true)]
        [string]$path,
        [Parameter(Mandatory = $true)]
        [string]$targetvalue,
        [Parameter(Mandatory = $false)]
        [string]$targetdata
    )
  
    # exctact json formatted array from file & Convert the JSON string to PowerShell objects
    $jsonArray = Get-Content -Path $path -Raw
    $jsonObjects = ConvertFrom-Json $jsonArray
  
    # function to search for the target key's value recursively
    function Get-ValueRecursively ($obj) {
      $result = @()
      if($targetdata){
        #if targetdata specified
        foreach ($property in $obj.PSObject.Properties) {
            if ($property.Value -is [System.Array]) {
                # If the value is an Array object use recursive function with item as input
                foreach ($item in $property.Value) {
                    $result += Get-ValueRecursively $item
                }
            }
             elseif ($property.Value -eq $targetvalue) {
                # If the value is "$targetvalue", extract the value assigned to defined parameter "$targetvalue"
                $result += $obj.$targetdata
            }
        }
        return $result
      }
      else{
        #if targetdata not specified
        foreach ($property in $obj.PSObject.Properties) {
            if ($property.Value -is [System.Array]) {
                foreach ($item in $property.Value) {
                    $result += Get-ValueRecursively $item
                }
            }
             elseif ($property.Value -eq $targetvalue) {
                # If the value is "$targetvalue", extract the whole object
                $result += $obj
            }
        }
        return $result
      }
    }
  
    # Loop through each object in the array and extract the data
    $extracteddara = @()
    foreach ($obj in $jsonObjects) {
        $extracteddara += Get-ValueRecursively $obj
    }
  
    # Output the extracted values
    return $extracteddara
  }
  
