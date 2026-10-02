param(
    [switch]$u
)

$DIR_PATH  = "./StarRail_Data/StreamingAssets/DesignData/Windows/"
$STATE_FILE = "./hken.txt"
$BAK_EXT   = ".hken.bak"

if ($u) {
    if (-not (Test-Path $STATE_FILE)) {
        Write-Host "hken.txt not found, nothing to undo."
        return
    }

    $name    = (Get-Content $STATE_FILE -Raw).Trim()
    $target  = Join-Path $DIR_PATH $name
    $backup  = $target + $BAK_EXT

    if (-not (Test-Path $backup)) {
        Write-Host "Backup not found: $backup"
        return
    }

    if (Test-Path $target) { Remove-Item $target -Force }
    Rename-Item -Path $backup -NewName $name
    Remove-Item $STATE_FILE -Force

    Write-Host "Restored: $name"
    return
}

if (Test-Path $STATE_FILE) {
    Write-Host "hken.txt already exists, game is already patched. Run with -u first."
    return
}

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

foreach ($file in Get-ChildItem -Path $DIR_PATH -File) {
    if ($file.Name.EndsWith($BAK_EXT)) { continue }

    $filePath = $file.FullName
    [byte[]]$content = [System.IO.File]::ReadAllBytes($filePath)

    $p1 = Find-PatternIndex $content $FONT_PAT
    $p2 = Find-PatternIndex $content $LANG_PAT

    if ($p1 -ge 0 -and $p2 -ge 0) {
        Write-Host "found: $($file.Name)"

        Copy-Item -Path $filePath -Destination ($filePath + $BAK_EXT) -Force
        Set-Content -Path $STATE_FILE -Value $file.Name -NoNewline

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
        Write-Host "done. Backup: $($file.Name)$BAK_EXT"
        break
    }
}
