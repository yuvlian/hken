# $DIR_PATH = "./StarRail_Data/StreamingAssets/DesignData/Windows/"
# $FONT_PAT = [System.Text.Encoding]::ASCII.GetBytes("SpriteOutput/UI/Fonts/RPG_CN.ttf")
# $LANG_PAT = [System.Text.Encoding]::ASCII.GetBytes("Korean")
# $REPLACE  = [System.Text.Encoding]::ASCII.GetBytes("en")

# function Find-PatternIndex ($Bytes, $Pattern) {
#     for ($i = 0; $i -le ($Bytes.Length - $Pattern.Length); $i++) {
#         $match = $true
#         for ($j = 0; $j -lt $Pattern.Length; $j++) {
#             if ($Bytes[$i + $j] -ne $Pattern[$j]) { $match = $false; break }
#         }
#         if ($match) { return $i }
#     }
#     return -1
# }

# function Apply-Patch ($Bytes, $StartIdx, $Gap, $Count) {
#     0..($Count - 1) | ForEach-Object {
#         $offset = $StartIdx + ($_ * ($Gap + $REPLACE.Length))
#         [Array]::Copy($REPLACE, 0, $Bytes, $offset, $REPLACE.Length)
#     }
# }

# Get-ChildItem -Path $DIR_PATH -File | ForEach-Object {
#     $filePath = $_.FullName
#     [byte[]]$content = [System.IO.File]::ReadAllBytes($filePath)

#     $p1 = Find-PatternIndex $content $FONT_PAT
#     $p2 = Find-PatternIndex $content $LANG_PAT

#     if ($p1 -ge 0 -and $p2 -ge 0) {
#         Write-Host "found: $($_.Name)"
#         Write-Host "patching..."

#         $baseIdx = $p2 + 14
#         Apply-Patch $content $baseIdx 1 4
   
#         $nextIdx = $baseIdx + (4 * 3) + 6
#         Apply-Patch $content $nextIdx 1 2

#         $nextIdx2 = $nextIdx + (2 * 3) + 6
#         Apply-Patch $content $nextIdx2 1 5

#         $nextIdx3 = $nextIdx2 + (5 * 3) + 5
#         Apply-Patch $content $nextIdx3 1 2

#         [System.IO.File]::WriteAllBytes($filePath, $content)
#         Write-Host "done."
#         exit
#     }
# }

$DIR_PATH="./StarRail_Data/StreamingAssets/DesignData/Windows/";$FONT_PAT=[System.Text.Encoding]::ASCII.GetBytes("SpriteOutput/UI/Fonts/RPG_CN.ttf");$LANG_PAT=[System.Text.Encoding]::ASCII.GetBytes("Korean");$REPLACE=[System.Text.Encoding]::ASCII.GetBytes("en");function F($B,$P){for($i=0;$i-le($B.Length-$P.Length);$i++){ $m=$true;for($j=0;$j-lt $P.Length;$j++){if($B[$i+$j]-ne $P[$j]){$m=$false;break}};if($m){return $i}};-1};function A($B,$S,$G,$C){0..($C-1)|%{ $o=$S+($_*($G+$REPLACE.Length));[Array]::Copy($REPLACE,0,$B,$o,$REPLACE.Length)}};Get-ChildItem -Path $DIR_PATH -File|%{ $f=$_.FullName;[byte[]]$c=[System.IO.File]::ReadAllBytes($f);$p1=F $c $FONT_PAT;$p2=F $c $LANG_PAT;if($p1-ge 0 -and $p2-ge 0){Write-Host "found: $($_.Name)";Write-Host "patching...";$b=$p2+14;A $c $b 1 4;$n=$b+(4*3)+6;A $c $n 1 2;$n2=$n+(2*3)+6;A $c $n2 1 5;$n3=$n2+(5*3)+5;A $c $n3 1 2;[System.IO.File]::WriteAllBytes($f,$c);Write-Host "done.";exit}}
