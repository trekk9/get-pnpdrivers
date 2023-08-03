function Get-PnpDrivers {
    # Pull all drivers from DriverStore
    $d = pnputil.exe /enum-drivers | Out-String

    # Split by blank line
    $nl = [System.Environment]::NewLine
    $items = ($d -split "$nl$nl")

    # Remove first and last index from items list, they are not driver items
    $count = $items.count
    $items = (($items | Select-Object -last ($count - 1)) | Select-Object -first ($count - 2))

    # Set result list
    $result = [system.collections.generic.list[pscustomobject]]::new()

    # Iterate items
    foreach ( $item in $items )
    {
        # Split items and trim any whitespace
        $lines = ( $item -split ":" -split "`n" ) | ForEach-Object { $_.trim() }
        # Set line number index
        $line_num = 0
        # Set hashtable placeholder for each item
        $hash = @{}
        # Iterate lines per item
        foreach ( $line in $lines )
        {
            # Get even number index as hash key
            if ( $line_num % 2 -eq 0 )
            {
                $key = $line
            }
            # Get odd number index as key value
            if ( $line_num % 2 -eq 1 ) 
            {
                $hash.$key = $line
            }
            $line_num += 1
        }
        $result.add(([PSCustomObject]$hash))
    }

    return $result
}