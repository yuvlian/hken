$DIR_PATH = "./StarRail_Data/StreamingAssets/DesignData/Windows/"
$FONT_PAT = [System.Text.Encoding]::ASCII.GetBytes("SpriteOutput/UI/Fonts/RPG_CN.ttf")
$LANG_PAT = [System.Text.Encoding]::ASCII.GetBytes("Korean")
$REPLACE  = [System.Text.Encoding]::ASCII.GetBytes("en")

function Find-PatternIndex ($Bytes, $Pattern) {
    for ($i = 0; $i -le ($Bytes.Length - $Pattern.Length); $i++) {
        $match = $true
        for ($j = 0; $j -lt $Pattern.Length; $j++) {
            if ($Bytes[$i + $j] -ne $Pattern[$j]) { $match = $false; break }
        }
        if ($match) { return $i }
    }
    return -1
}

function Apply-Patch ($Bytes, $StartIdx, $Gap, $Count) {
    0..($Count - 1) | ForEach-Object {
        $offset = $StartIdx + ($_ * ($Gap + $REPLACE.Length))
        [Array]::Copy($REPLACE, 0, $Bytes, $offset, $REPLACE.Length)
    }
}

Get-ChildItem -Path $DIR_PATH -File | ForEach-Object {
    $filePath = $_.FullName
    [byte[]]$content = [System.IO.File]::ReadAllBytes($filePath)

    $p1 = Find-PatternIndex $content $FONT_PAT
    $p2 = Find-PatternIndex $content $LANG_PAT

    if ($p1 -ge 0 -and $p2 -ge 0) {
        Write-Host "found: $($_.Name)"
        Write-Host "patching..."

        $baseIdx = $p2 + 14
        Apply-Patch $content $baseIdx 1 4
   
        $nextIdx = $baseIdx + (4 * 3) + 6
        Apply-Patch $content $nextIdx 1 2

        $nextIdx2 = $nextIdx + (2 * 3) + 6
        Apply-Patch $content $nextIdx2 1 5

        $nextIdx3 = $nextIdx2 + (5 * 3) + 5
        Apply-Patch $content $nextIdx3 1 2

        [System.IO.File]::WriteAllBytes($filePath, $content)
        Write-Host "done."
        exit
    }
}
